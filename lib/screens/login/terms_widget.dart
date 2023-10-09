import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsWidget extends StatefulWidget {
  @override
  _TermsWidgetState createState() => _TermsWidgetState();
}

class _TermsWidgetState extends State<TermsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 2),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: AppLocalizations.of(context).byContinueRegistration + ' ',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1),
            ),
            TextSpan(
              text: AppLocalizations.of(context).registrationPolicies + ' ',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch('https://packedoo.com/terms');
                },
            ),
            TextSpan(
              text: AppLocalizations.of(context).packedooService,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1),
            )
          ],
        ),
      ),
    );
  }
}
