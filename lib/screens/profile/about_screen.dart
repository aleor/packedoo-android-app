import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/styles.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    GoogleAnalytics().setScreen('about_app');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).aboutApp),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                _logo(),
                _version(),
                _description(),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _copyright(),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget _logo() {
    return Center(
      child: Container(
        child: Image.asset(
          'assets/images/logo_title_img.png',
          height: 100,
          width: 140,
        ),
      ),
    );
  }

  Widget _version() {
    return Container(
      child: Text(
        AppLocalizations.of(context).version + ' 1.3.3',
        style: TextStyle(
          color: Styles.kGreyTextColor,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _description() {
    return Container(
      padding: const EdgeInsets.only(top: 120),
      child: Text(
        AppLocalizations.of(context).packedooSlogan,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Styles.kGreyTextColor,
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _copyright() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        'ⓒ Packedoo, 2020',
        style: TextStyle(
          fontSize: 16,
          color: Styles.kGreyTextColor,
        ),
      ),
    );
  }
}
