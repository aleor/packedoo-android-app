import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/services/users.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:flutter/scheduler.dart';
import 'package:quiver/strings.dart';

class EditPhoneScreen extends StatefulWidget {
  final String phoneNr;
  final bool isVerified;

  const EditPhoneScreen({Key key, this.phoneNr, this.isVerified})
      : super(key: key);

  @override
  _EditPhoneScreenState createState() => _EditPhoneScreenState();
}

class _EditPhoneScreenState extends State<EditPhoneScreen> {
  UsersService _usersService = usersService;
  UIService _uiService = uiService;
  TextEditingController _phoneNumberController = TextEditingController();
  StateWidgetState appState;

  bool _phoneVerified;
  String _phoneNumber;
  String _updatedNumber;
  bool _isLoading = true;

  Country _selectedCountry = Country.RU;

  final _focusNode = FocusNode();

  @override
  void initState() {
    GoogleAnalytics().setScreen('edit_phone');

    _phoneVerified = widget.isVerified;
    _phoneNumber = widget.phoneNr;

    SchedulerBinding.instance.addPostFrameCallback((_) => _processPhoneNr());
    super.initState();
  }

  Future _processPhoneNr() async {
    if (!_phoneVerified || isEmpty(widget.phoneNr)) {
      await _ensurePhoneData();
    }

    if (isEmpty(_phoneNumber)) {
      NavigationService.replaceWithAddPhone();
      return;
    }

    final _phoneData =
        await PhoneNumber.getRegionInfoFromPhoneNumber(_phoneNumber);
    _selectedCountry = PackConstants.kIsoCodeCountryMap[_phoneData.isoCode];
    _phoneNumberController.text = _phoneData.parseNumber();

    setState(() {
      _updatedNumber = _phoneData.phoneNumber;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).phone)),
      body: _isLoading ? Center(child: CustomCircularIndicator()) : _mainBody(),
    );
  }

  Widget _mainBody() {
    return SingleChildScrollView(
      child: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: Container(
            padding: EdgeInsets.only(top: 25, left: 16, right: 16),
            child: Column(children: <Widget>[
              _currentPhoneNumber(),
              _getComment(),
              if (_phoneChanged) _updateButton(),
              if (!_phoneVerified && !_phoneChanged) _confirmButton(),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _getComment() {
    var text = _phoneChanged
        ? AppLocalizations.of(context).phoneNumberChangedNotSaved
        : (_phoneVerified)
            ? AppLocalizations.of(context).phoneNumberConfirmed
            : AppLocalizations.of(context).phoneNumberNotConfirmedLimitations;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 10, left: 16, right: 16),
      child: Text(text),
    );
  }

  Widget _updateButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 40),
      child: RaisedButton(
        child: Text(
          AppLocalizations.of(context).saveNewNumber,
          style: Styles.kButtonUpperTextStyle,
        ),
        color: Styles.kGreenColor,
        onPressed: _changeNumber,
      ),
    );
  }

  Widget _confirmButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 40),
      child: RaisedButton(
        child: Text(
          AppLocalizations.of(context).confirmNumber,
          style: Styles.kButtonUpperTextStyle,
        ),
        color: Styles.kGreenColor,
        onPressed: _toPhoneConfirmation,
      ),
    );
  }

  Widget _currentPhoneNumber() {
    return Container(
      padding: EdgeInsets.only(left: 12),
      height: 46,
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber value) {
          setState(() {
            _updatedNumber = value.phoneNumber;
          });
        },
        focusNode: _focusNode,
        initialCountry2LetterCode:
            PackConstants.kCountryIsoCodeMap[_selectedCountry],
        textFieldController: _phoneNumberController,
        countries: PackConstants.kSupportedCountries,
        hintText: AppLocalizations.of(context).phoneNumber,
      ),
    );
  }

  Future _changeNumber() async {
    if (_updatedNumber.replaceAll('+', '').length !=
        PackConstants.kCountryMobileLength[_selectedCountry]) {
      _uiService.showInfoDialog(context, AppLocalizations.of(context).warning,
          AppLocalizations.of(context).invalidPhoneNumberFormat);
      return;
    }

    _uiService.showActivityIndicator(context);

    try {
      await _usersService.addPhoneNumber(_updatedNumber);
    } catch (e) {
      _uiService.hideActivityIndicator(context, true);
      _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).error,
        AppLocalizations.of(context).unableToSaveNumberTryLater,
      );
      return;
    }

    _uiService.hideActivityIndicator(context, true);
    await _uiService.showInfoDialog(
      context,
      AppLocalizations.of(context).updated,
      AppLocalizations.of(context).phoneNumberSavedSuccessfully,
    );

    appState.setPhone(_updatedNumber);

    _toPhoneConfirmation();
  }

  void _toPhoneConfirmation() {
    NavigationService.toConfirmPhone();
  }

  Future _ensurePhoneData() async {
    final _isPhoneVerified = await _usersService.isPhoneVerified();
    final _actualPhoneNumber = await _usersService.getPhoneNumber();

    setState(() {
      _phoneVerified = _isPhoneVerified;
      _phoneNumber = _actualPhoneNumber;
    });
  }

  bool get _phoneChanged => _updatedNumber != _phoneNumber;
}
