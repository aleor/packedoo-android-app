import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/new_user.dart';
import 'package:packedoo_app_material/screens/login/terms_widget.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/services/users.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';

class RegisterViaEmailScreen extends StatefulWidget {
  @override
  _RegisterViaEmailScreenState createState() => _RegisterViaEmailScreenState();
}

class _RegisterViaEmailScreenState extends State<RegisterViaEmailScreen> {
  UIService _uiService = uiService;
  UsersService _usersService = usersService;

  double _screenHeight = 0.0;
  StateWidgetState state;

  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();

  final _focusNode = FocusNode();

  String _phoneNumber;
  Country _selectedCountry = Country.RU;

  @override
  void initState() {
    GoogleAnalytics().setScreen('register_via_email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    state = StateWidget.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: Container(
            height: _screenHeight,
            padding: EdgeInsets.only(top: 35, left: 16, right: 16, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _packedooLogo(),
                _nameField(),
                _surnameField(),
                _emailField(),
                _passwordField(),
                _phoneField(),
                _createAccountButton(),
                _cancelButton(),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TermsWidget(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _packedooLogo() {
    return Container(
      height: 100,
      padding: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Image.asset('assets/images/logo_title_img.png'),
    );
  }

  Widget _nameField() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: TextField(
        controller: _nameController,
        autocorrect: false,
        decoration:
            InputDecoration(labelText: AppLocalizations.of(context).name),
      ),
    );
  }

  Widget _surnameField() {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: TextField(
        controller: _surnameController,
        autocorrect: false,
        decoration:
            InputDecoration(labelText: AppLocalizations.of(context).surname),
      ),
    );
  }

  Widget _emailField() {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: TextField(
        controller: _loginController,
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(labelText: 'E-mail'),
      ),
    );
  }

  Widget _phoneField() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber value) {
          _parsePhone(value);
        },
        focusNode: _focusNode,
        initialCountry2LetterCode: PackConstants.kCountryIsoCodeMap[Country.RU],
        countries: PackConstants.kSupportedCountries,
        hintText: AppLocalizations.of(context).phoneNumber,
        onSubmit: _createAccount,
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: TextField(
          controller: _passwordController,
          autocorrect: false,
          obscureText: true,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).password)),
    );
  }

  Widget _createAccountButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 40),
      child: FlatButton(
        color: Styles.kGreenColor,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Text(
            AppLocalizations.of(context).createAccountUpper,
            textAlign: TextAlign.center,
            style: Styles.kButtonUpperTextStyle,
          ),
        ),
        onPressed: _createAccount,
      ),
    );
  }

  Widget _cancelButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10),
      child: FlatButton(
        child: Container(
          child: Text(
            AppLocalizations.of(context).cancel,
            textAlign: TextAlign.center,
            style: TextStyle(color: Styles.kGreenColor, fontSize: 16),
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  _parsePhone(PhoneNumber value) {
    _phoneNumber = value.phoneNumber;
    _selectedCountry = PackConstants.kIsoCodeCountryMap[value.isoCode];
  }

  Future _createAccount() async {
    final _isValid = await _validateInputs();

    if (!_isValid) {
      return;
    }

    final _user = NewUser(
      firstName: _nameController.text.trim(),
      lastName: _surnameController.text.trim(),
      email: _loginController.text.trim(),
      password: _passwordController.text.trim(),
      phoneNumber: _phoneNumber,
      locale: state.state.lang,
    );

    final _userCreated = await _postRequest(_user);

    if (!_userCreated) {
      return;
    }

    _updateState(_user);

    NavigationService.toUserCreated(_user);
  }

  _updateState(_user) {
    state.setPhone(_user.phoneNumber);
    state.setDisplayName('${_user.firstName} ${_user.lastName}');
  }

  Future<bool> _validateInputs() async {
    final inputControllers = [
      _nameController,
      _surnameController,
      _loginController,
      _passwordController
    ];

    if (inputControllers.any((c) => isEmpty(c.text?.trim())) ||
        isEmpty(_phoneNumber)) {
      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).missingData,
        AppLocalizations.of(context).pleaseFillInAllFields,
      );
      return false;
    }

    if (_passwordController.text.length < 6) {
      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).missingData,
        AppLocalizations.of(context).passwordShouldHaveAtLeast6,
      );
      return false;
    }

    bool isValidEmail = RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(_loginController.text);

    if (!isValidEmail) {
      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).error,
        AppLocalizations.of(context).invalidEmail,
      );
      return false;
    }

    if (_phoneNumber.replaceAll('+', '').length !=
        PackConstants.kCountryMobileLength[_selectedCountry]) {
      await _uiService.showInfoDialog(
          context,
          AppLocalizations.of(context).warning,
          AppLocalizations.of(context).invalidPhoneNumberFormat);
      return false;
    }

    return true;
  }

  Future<bool> _postRequest(NewUser user) async {
    _uiService.showActivityIndicator(context);

    try {
      await _usersService.createNewUser(user);
    } catch (error) {
      String _errorMessage;

      _uiService.hideActivityIndicator(context, true);
      switch (error.code) {
        case ('ERROR_INVALID_EMAIL'):
          _errorMessage = AppLocalizations.of(context).invalidEmail;
          break;
        case ('ERROR_EMAIL_ALREADY_IN_USE'):
          _errorMessage = AppLocalizations.of(context).emailTaken;
          break;
      }

      await _uiService.showInfoDialog(
          context, AppLocalizations.of(context).error, _errorMessage);

      return false;
    }

    _uiService.hideActivityIndicator(context, true);

    return true;
  }
}
