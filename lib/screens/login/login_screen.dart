import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/screens/login/terms_widget.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  StateWidgetState appState;
  UIService _uiService = uiService;

  @override
  void initState() {
    GoogleAnalytics().setScreen('login_options');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context);

    return Scaffold(
      body: _getLoginOptions(),
    );
  }

  Widget _getLoginOptions() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 35),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            _packedooLogo(),
            _signInWithGoogleButton(),
            _signInWithEmailButton(),
            _noAccount(),
            _registerButton(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: EdgeInsets.only(bottom: 10), child: TermsWidget()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _packedooLogo() {
    return Container(
      height: 120,
      padding: EdgeInsets.only(top: 40, left: 40, right: 40),
      alignment: Alignment.center,
      child: Image.asset('assets/images/logo_title_img.png'),
    );
  }

  Widget _signInWithGoogleButton() {
    return Container(
      padding: EdgeInsets.only(top: 100, left: 40, right: 40),
      child: RaisedButton(
        elevation: 15,
        padding: EdgeInsets.zero,
        child: Image.asset(
          _localizedGoogleLoginButton,
          fit: BoxFit.cover,
        ),
        onPressed: _signInWithGoogle,
      ),
    );
  }

  Widget _signInWithEmailButton() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 40, right: 40),
      child: RaisedButton(
        elevation: 15,
        padding: EdgeInsets.zero,
        child: Image.asset(
          _localizedEmailLoginButton,
          fit: BoxFit.contain,
        ),
        onPressed: _signInWithEmail,
      ),
    );
  }

  Future _signInWithGoogle() async {
    _uiService.showActivityIndicator(context);
    final _isLoggedIn = await appState.signInWithGoogle();
    _uiService.hideActivityIndicator(context, true);

    if (!_isLoggedIn) {
      _showLoginFailedAlert();
    }
  }

  _signInWithEmail() {
    NavigationService.toEmailLogin();
  }

  _registerViaEmail() {
    NavigationService.toEmailRegistration();
  }

  _showLoginFailedAlert() {
    final title = AppLocalizations.of(context).loginFailed;
    final message = AppLocalizations.of(context).googleLoginFailed;

    _uiService.showInfoDialog(context, title, message);
  }

  Widget _noAccount() {
    return Container(
      padding: EdgeInsets.only(top: 40),
      child: Text(
        AppLocalizations.of(context).doNotHaveAnAccount,
        style: TextStyle(fontSize: 16, color: Styles.kGreyTextColor),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: FlatButton(
        child: Text(AppLocalizations.of(context).registerUpper,
            style: TextStyle(
              fontSize: 18,
              color: Styles.kGreenColor,
              letterSpacing: 2,
            )),
        onPressed: _registerViaEmail,
      ),
    );
  }

  String get _localizedGoogleLoginButton =>
      (appState.state.locale == PackConstants.kLangLocaleMap[Lang.RU])
          ? 'assets/images/login_buttons/google_ru.png'
          : 'assets/images/login_buttons/google_en.png';

  String get _localizedEmailLoginButton =>
      (appState.state.locale == PackConstants.kLangLocaleMap[Lang.RU])
          ? 'assets/images/login_buttons/email_ru.png'
          : 'assets/images/login_buttons/email_en.png';
}
