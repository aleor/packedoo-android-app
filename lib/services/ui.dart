import 'package:flutter/material.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';

final UIService uiService = UIService();

class UIService {
  showInfoDialog(BuildContext context, String title, String message,
      {String actionText = 'OK'}) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FlatButton(
              child: Text(actionText ?? 'OK'),
              onPressed: () {
                Navigator.pop(context, actionText ?? 'OK');
              })
        ],
      ),
    );
  }

  showConfirmationDialog(BuildContext context, String title, String message,
      {String confirmActionText = 'OK',
      String declineActionText = 'Отмена'}) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FlatButton(
              child: Text(confirmActionText),
              onPressed: () {
                Navigator.pop(context, true);
              }),
          FlatButton(
              child: Text(declineActionText),
              onPressed: () {
                Navigator.pop(context, false);
              })
        ],
      ),
    );
  }

  showActivityIndicator(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Center(
        child: CustomCircularIndicator(),
      ),
    );
  }

  hideActivityIndicator(BuildContext context, bool isRootNavigator) {
    Navigator.of(context, rootNavigator: isRootNavigator).pop();
  }
}
