import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/packedoo_main_page.dart';
import 'package:packedoo_app_material/screens/login/login_screen.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';

class PackedooApp extends StatefulWidget {
  @override
  _PackedooAppState createState() => _PackedooAppState();
}

class _PackedooAppState extends State<PackedooApp> {
  StateModel state;

  @override
  Widget build(BuildContext context) {
    state = StateWidget.of(context).state;
    var _appTheme = Theme.of(context);

    return MaterialApp(
      locale: state.locale,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales(),
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      theme: _appTheme.copyWith(
        primaryColor: Colors.white,
        accentColor: Styles.kGreenColor,
        scaffoldBackgroundColor: Colors.white,
        primaryTextTheme: _appTheme.primaryTextTheme.copyWith(
            headline6: _appTheme.primaryTextTheme.headline6
                .copyWith(fontWeight: FontWeight.w400, color: Colors.black)),
        primaryIconTheme:
            _appTheme.primaryIconTheme.copyWith(color: Colors.black),
      ),
      routes: {
        '/': (context) => PackedooMainPage(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
