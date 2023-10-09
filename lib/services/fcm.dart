import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:packedoo_app_material/services/users.dart';

final FCMService fcmService = FCMService();

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final UsersService _usersService = usersService;

  init() {
    _firebaseMessaging.requestNotificationPermissions();
    _configure();
    _listenTokenChange();
  }

  _configure() {
    _firebaseMessaging.configure(
      onMessage: (Map<dynamic, dynamic> message) => _onMessage(message),
      onResume: (Map<dynamic, dynamic> message) => _onResume(message),
      onLaunch: (Map<dynamic, dynamic> message) => _onLaunch(message),
    );
  }

  writeFCMToken({String token}) async {
    var _fcmToken = token ?? await _firebaseMessaging.getToken();

    _usersService.writeFCMToken(_fcmToken);
  }

  _listenTokenChange() {
    _firebaseMessaging.onTokenRefresh
        .listen((token) => writeFCMToken(token: token));
  }

  _onMessage(Map<dynamic, dynamic> message) {
    print('on message: ');
    print(message);
  }

  _onResume(Map<dynamic, dynamic> message) {
    print('on resume: ');
    print(message);
  }

  _onLaunch(Map<dynamic, dynamic> message) {
    print('on launch: ');
    print(message);
  }
}
