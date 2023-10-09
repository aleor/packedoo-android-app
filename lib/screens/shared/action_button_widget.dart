import 'package:flutter/material.dart';
import 'package:packedoo_app_material/styles.dart';

class ActionButton extends StatelessWidget {
  final Icon icon;
  final String text;
  final Function onPressedHandler;

  const ActionButton({Key key, this.icon, this.text, this.onPressedHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          IconButton(
            icon: icon,
            onPressed: onPressedHandler,
            iconSize: 28,
            color: Styles.kGreyTextColor,
          ),
          Text(
            text ?? '',
            style: TextStyle(color: Styles.kGreyTextColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
