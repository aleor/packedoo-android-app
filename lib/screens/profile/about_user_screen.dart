import 'dart:async';

import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/services/users.dart';
import 'package:packedoo_app_material/styles.dart';

class AboutUserScreen extends StatefulWidget {
  final String about;

  const AboutUserScreen({Key key, this.about}) : super(key: key);

  @override
  _AboutUserScreenState createState() => _AboutUserScreenState();
}

class _AboutUserScreenState extends State<AboutUserScreen> {
  UIService _uiService = uiService;
  UsersService _usersService = usersService;
  TextEditingController _aboutCtrl;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _aboutCtrl = TextEditingController(text: widget.about);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tellAboutYourself),
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(_focusNode);
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 16, right: 16),
          child: Column(
            children: <Widget>[
              _inputField(),
              _actionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField() {
    return TextField(
      textInputAction: TextInputAction.done,
      controller: _aboutCtrl,
      minLines: 1,
      maxLines: 10,
      maxLength: 1024,
      decoration: InputDecoration(
        helperMaxLines: 5,
        helperText: AppLocalizations.of(context).aboutUserHelperText,
      ),
    );
  }

  Widget _actionButton() {
    return Container(
      padding: EdgeInsets.only(top: 50),
      width: double.infinity,
      child: RaisedButton(
        color: Styles.kGreenColor,
        child: Text(AppLocalizations.of(context).save,
            style: Styles.kButtonUpperTextStyle),
        onPressed: _save,
      ),
    );
  }

  _save() async {
    _uiService.showActivityIndicator(context);

    try {
      await _usersService.updateAboutMe(_aboutCtrl.text);
    } catch (e) {
      _uiService.hideActivityIndicator(context, true);
      await _uiService.showInfoDialog(
          context,
          AppLocalizations.of(context).error,
          AppLocalizations.of(context).unableToPerformCall);
      return;
    }

    // It takes some time to update the data on Firebase, so let's not rush to come back..
    Timer(Duration(seconds: 1), () {
      _uiService.hideActivityIndicator(context, true);
      Navigator.pop(context, true);
    });
  }
}
