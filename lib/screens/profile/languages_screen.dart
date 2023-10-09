import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/state_widget.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  StateWidgetState appState;

  @override
  void initState() {
    GoogleAnalytics().setScreen('select_lang');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).interfaceLang),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 5, left: 16),
            child: Column(children: <Widget>[
              _getOption(lang: Lang.RU),
              Divider(indent: 8),
              _getOption(lang: Lang.EN),
              Divider(indent: 8),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _getOption({lang: Lang}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _setLocale(lang),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (_isCurrent(lang))
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.blue,
                    size: 24,
                  ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: _isCurrent(lang) ? 0 : 24),
                height: 34,
                alignment: Alignment.centerLeft,
                child: Text(PackConstants.kLangStringMap[lang]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setLocale(Lang lang) {
    appState.setLocale(PackConstants.kLangLocaleMap[lang]);
  }

  bool _isCurrent(Lang lang) {
    return appState.state.locale == PackConstants.kLangLocaleMap[lang];
  }
}
