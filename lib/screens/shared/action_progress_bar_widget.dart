import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/styles.dart';

class ActionProgressBar extends StatelessWidget {
  final double value;
  final String buttonTitle;
  final Function handler;

  const ActionProgressBar(
      {Key key, this.value = 0, this.handler, this.buttonTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 12),
      height: 50,
      color: Color(0xfff5f5f5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
                height: 2,
                child: LinearProgressIndicator(
                  backgroundColor: Styles.kProgressBarBgColor,
                  value: value,
                )),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: RaisedButton(
              child: Padding(
                padding: _buttonTitlePadding,
                child: Text(
                  buttonTitle ?? AppLocalizations.of(context).continueUpper,
                  style: TextStyle(
                    letterSpacing: 0.3,
                    color: Colors.white,
                  ),
                ),
              ),
              color: Styles.kGreenColor,
              onPressed: handler,
            ),
          )
        ],
      ),
    );
  }

  EdgeInsets get _buttonTitlePadding =>
      buttonTitle != null && buttonTitle.length < 8
          ? EdgeInsets.symmetric(horizontal: 20)
          : EdgeInsets.zero;
}
