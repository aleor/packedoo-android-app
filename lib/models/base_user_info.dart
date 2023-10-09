import 'package:quiver/strings.dart';

class BaseUserInfo {
  String displayName;
  String photoUrl;
  double rating;
  String uid;

  BaseUserInfo.fromMap(Map<dynamic, dynamic> map) {
    displayName = map['displayName'];
    photoUrl = map['photoURL'];
    rating = map['rating'] != null ? double.parse(map['rating'].toString()) : 0;
    uid = map['uid'];
  }

  String get safeUserName => isEmpty(displayName) ? '' : displayName;

  BaseUserInfo();
}
