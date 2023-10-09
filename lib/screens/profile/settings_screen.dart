import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = authService;
  StateModel _state;

  @override
  void initState() {
    GoogleAnalytics().setScreen('settings');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _state = StateWidget.of(context).state;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).settings)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _settings(),
              _logoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _languageSettings(),
        _terms(),
        _about(),
      ],
    );
  }

  Widget _languageSettings() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _selectLang,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                AppLocalizations.of(context).interfaceLang,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(_getCurrentLang(),
                  style: TextStyle(color: Styles.kGreyTextColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _terms() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _showTermsWeb,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 24),
        child: Text(
          AppLocalizations.of(context).serviceTerms,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _about() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toAboutScreen,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 24),
        child: Text(
          AppLocalizations.of(context).aboutApp,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _logout,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 26),
        child: Text(
          AppLocalizations.of(context).logout,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  _showTermsWeb() {
    var _packedooWeb =
        PackConstants.getPackedooWeb(locale: _state.locale, isDev: false);

    launch('$_packedooWeb/terms');
  }

  String _getCurrentLang() {
    return _state.locale == null
        ? ''
        : PackConstants.kLocaleLangValueMap[_state.locale];
  }

  _selectLang() {
    NavigationService.toLanguages();
  }

  _toAboutScreen() {
    NavigationService.toAbout();
  }

  _logout() {
    _authService.logout();
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }
}
