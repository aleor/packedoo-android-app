import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:packedoo_app_material/models/counters.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/users.dart';

final AppBadge appBadge = AppBadge();

class AppBadge {
  final _usersService = usersService;
  final _authService = authService;

  init() {
    _authService.userChanged.listen((user) => _listenCounters());
  }

  _listenCounters() {
    var _user = _authService.currentUserId;
    if (_user == null) {
      return;
    }

    _usersService
        .userCounters(userId: _user)
        .listen((data) => _updateAppBadgeIcon(data));
  }

  _updateAppBadgeIcon(Counters data) {
    (data?.pendingTotal != 0)
        ? FlutterAppBadger.updateBadgeCount(data.pendingTotal)
        : FlutterAppBadger.removeBadge();
  }
}
