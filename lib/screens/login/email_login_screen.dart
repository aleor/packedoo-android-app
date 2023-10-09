import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/screens/login/terms_widget.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';

class EmailLoginScreen extends StatefulWidget {
  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  UIService _uiService = uiService;
  AuthService _authService = authService;

  double _screenHeight = 0.0;

  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _focusNode = FocusNode();

  @override
  void initState() {
    GoogleAnalytics().setScreen('email_login');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                _loginField(),
                _passwordField(),
                _loginButtons(),
                _otherLoginOptionsLink(),
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
      height: 120,
      padding: EdgeInsets.only(top: 40, left: 16, right: 16),
      alignment: Alignment.center,
      child: Image.asset('assets/images/logo_title_img.png'),
    );
  }

  Widget _loginField() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: TextField(
        controller: _loginController,
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(labelText: 'E-mail'),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      child: TextField(
          controller: _passwordController,
          autocorrect: false,
          obscureText: true,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).password)),
    );
  }

  Widget _loginButtons() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: 30),
      child: FlatButton(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        color: Styles.kGreenColor,
        child: Text(
          AppLocalizations.of(context).logInUpper,
          style: Styles.kButtonUpperTextStyle,
        ),
        onPressed: _tryToLogin,
      ),
    );
  }

  Widget _otherLoginOptionsLink() {
    return Container(
      padding: EdgeInsets.only(top: 50),
      alignment: Alignment.center,
      child: FlatButton(
        child: Text(
          AppLocalizations.of(context).otherLoginOptions,
          style: TextStyle(
            color: Styles.kGreenColor,
            fontSize: 18,
            letterSpacing: 0.8,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  void _tryToLogin() async {
    if (isEmpty(_loginController.text) || isEmpty(_passwordController.text)) {
      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).logIn,
        AppLocalizations.of(context).emailAndPasswordRequired,
      );
      return;
    }

    _uiService.showActivityIndicator(context);

    bool _loggedIn = false;

    try {
      _loggedIn = await _authService.signInWithEmailAndPassword(
          email: _loginController.text, password: _passwordController.text);
    } catch (error) {
      String _errorMessage;

      _uiService.hideActivityIndicator(context, true);

      switch (error.code) {
        case ('ERROR_INVALID_EMAIL'):
        case ('ERROR_WRONG_PASSWORD'):
        case ('ERROR_USER_NOT_FOUND'):
          _errorMessage = AppLocalizations.of(context).invalidEmailOrPassword;
          break;

        case ('ERROR_USER_DISABLED'):
          _errorMessage = AppLocalizations.of(context).userDisabled;
          break;
      }

      await _uiService.showInfoDialog(
          context, AppLocalizations.of(context).error, _errorMessage);

      return;
    }

    if (_loggedIn) {
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }
}
