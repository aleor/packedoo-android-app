import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/services/users.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AddPhoneScreen extends StatefulWidget {
  @override
  _AddPhoneScreenState createState() => _AddPhoneScreenState();
}

class _AddPhoneScreenState extends State<AddPhoneScreen> {
  UIService _uiService = uiService;
  UsersService _usersService = usersService;

  FocusNode _focusNode = FocusNode();

  StateWidgetState _appState;
  String _phoneNumber;
  Country _selectedCountry = Country.RU;

  @override
  Widget build(BuildContext context) {
    _appState = StateWidget.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context).unknownPhoneNumber),
        actions: <Widget>[
          Center(
            child: FlatButton(
              child: Text(
                AppLocalizations.of(context).skip,
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              onPressed: _skipConfirmation,
            ),
          )
        ],
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _noPhoneMessage(),
              _phoneField(),
              _addPhoneButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _noPhoneMessage() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${AppLocalizations.of(context).phoneNumberMissing}.',
            style: TextStyle(fontSize: 16, color: Styles.kGreyTextColor),
          ),
          SizedBox(height: 10),
          Text(
            AppLocalizations.of(context).phoneConfirmationReason,
            style: TextStyle(fontSize: 16, color: Styles.kGreyTextColor),
          ),
        ],
      ),
    );
  }

  Widget _phoneField() {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 10),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber value) {
          _parsePhone(value);
        },
        focusNode: _focusNode,
        initialCountry2LetterCode: PackConstants.kCountryIsoCodeMap[Country.RU],
        countries: PackConstants.kSupportedCountries,
        hintText: AppLocalizations.of(context).phoneNumber,
      ),
    );
  }

  Widget _addPhoneButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 30),
      child: RaisedButton(
        color: Styles.kGreenColor,
        child: Text(
          AppLocalizations.of(context).addPhone,
          style: Styles.kButtonUpperTextStyle,
        ),
        onPressed: _addPhone,
      ),
    );
  }

  _parsePhone(PhoneNumber value) {
    _phoneNumber = value.phoneNumber;
    _selectedCountry = PackConstants.kIsoCodeCountryMap[value.isoCode];
  }

  void _addPhone() async {
    if (_phoneNumber.replaceAll('+', '').length !=
        PackConstants.kCountryMobileLength[_selectedCountry]) {
      _uiService.showInfoDialog(context, AppLocalizations.of(context).warning,
          AppLocalizations.of(context).invalidPhoneNumberFormat);
      return;
    }

    _uiService.showActivityIndicator(context);
    try {
      await _usersService.addPhoneNumber(_phoneNumber);
    } catch (error) {
      _uiService.hideActivityIndicator(context, true);
      _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).error,
        AppLocalizations.of(context).failedToAddPhone,
      );
      return;
    }

    _uiService.hideActivityIndicator(context, true);

    _appState.setPhone(_phoneNumber);

    NavigationService.toConfirmPhone(dialog: false);
  }

  _skipConfirmation() async {
    bool skipConfirmed = await _uiService.showConfirmationDialog(
      context,
      AppLocalizations.of(context).warning,
      AppLocalizations.of(context).phoneNotConfirmedLimitations,
      confirmActionText: AppLocalizations.of(context).skip,
      declineActionText: AppLocalizations.of(context).addNumber,
    );

    if (skipConfirmed) {
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }
}
