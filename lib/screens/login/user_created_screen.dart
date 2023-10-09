import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/new_user.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/styles.dart';

class UserCreatedScreen extends StatefulWidget {
  final NewUser user;

  const UserCreatedScreen({Key key, @required this.user}) : super(key: key);

  @override
  _UserCreatedScreenState createState() => _UserCreatedScreenState();
}

class _UserCreatedScreenState extends State<UserCreatedScreen> {
  @override
  void initState() {
    GoogleAnalytics().setScreen('user_created');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 35, left: 16, right: 16, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _packedooLogo(),
                _infoColumn(),
                _actionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _packedooLogo() {
    return Container(
      padding: EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/logo_title_img.png',
        height: 100,
      ),
    );
  }

  Widget _infoColumn() {
    return Container(
      padding: EdgeInsets.only(top: 40),
      child: Column(
        children: <Widget>[
          _accountCreatedText(),
          _pleaseConfirmPhoneText(),
          _profileText(),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RaisedButton(
            color: Styles.kGreenColor,
            child: Container(
                child: Text(
              AppLocalizations.of(context).confirmNumberUpper,
              style: Styles.kButtonUpperTextStyle,
            )),
            onPressed: _toConfirmPhoneScreen,
          ),
          FlatButton(
            child: Container(
                child: Text(
              AppLocalizations.of(context).skip,
              style: TextStyle(color: Styles.kGreenColor, fontSize: 16),
            )),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
    );
  }

  Widget _accountCreatedText() {
    return Container(
      child: Text(AppLocalizations.of(context).accountCreatedSuccessfully,
          style: TextStyle(fontSize: 24)),
    );
  }

  Widget _pleaseConfirmPhoneText() {
    return Container(
      padding: EdgeInsets.only(top: 36),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.phone,
            color: Colors.grey,
            size: 40,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                AppLocalizations.of(context).confirmPhoneToSendAndDeliver,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileText() {
    return Container(
      padding: EdgeInsets.only(top: 28),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: 40,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              AppLocalizations.of(context).youCanChangePhoneUnderProfile,
              style: TextStyle(fontSize: 16),
            ),
          )),
        ],
      ),
    );
  }

  _toConfirmPhoneScreen() {
    NavigationService.toConfirmPhone(dialog: false);
  }
}
