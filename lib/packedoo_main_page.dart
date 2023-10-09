import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/screens/login/login_screen.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/services/app_badge.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/current_location.dart';
import 'package:packedoo_app_material/services/fcm.dart';
import 'package:packedoo_app_material/state_widget.dart';

import 'screens/lots/all_lots_screen.dart';

class PackedooMainPage extends StatefulWidget {
  static final kTabBarKey = GlobalKey<_PackedooMainPageState>();

  @override
  _PackedooMainPageState createState() => _PackedooMainPageState();
}

class _PackedooMainPageState extends State<PackedooMainPage> {
  CurrentLocationService _currentLocationService = currentLocationService;
  AuthService _authService = authService;
  FCMService _fcmService = fcmService;
  AppBadge _appBadgeService = appBadge;

  StateModel appState;

  @override
  void initState() {
    _fcmService.init();
    _appBadgeService.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (appState.currentLocation == null) {
      _currentLocationService.storeLocationSilently(context);
    }
    return _buildContent();
  }

  Widget _buildContent() {
    if (appState.isLoading) {
      return Scaffold(
        body: Center(
          child: CustomCircularIndicator(),
        ),
      );
    } else if (!appState.isLoading && _authService.currentUserId == null) {
      return LoginScreen();
    } else {
      return AllLotsScreen();
    }
  }
}
