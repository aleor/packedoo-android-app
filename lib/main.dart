import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:packedoo_app_material/app.dart';
import 'package:packedoo_app_material/state_widget.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:packedoo_app_material/styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Crashlytics.instance.enableInDevMode = true;

  // ErrorWidget.builder = (FlutterErrorDetails details) => CustomErrorScreen();
  FlutterError.onError = (FlutterErrorDetails details) async {
    await Crashlytics.instance.recordFlutterError(details);
    // exit(-1);
  };

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Styles.kGreenColor));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) {
      runApp(
        StateWidget(
          child: PackedooApp(),
        ),
      );
    },
  );
}
