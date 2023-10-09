import 'package:firebase_auth/firebase_auth.dart';
import 'package:packedoo_app_material/models/base_user_info.dart';
import 'package:packedoo_app_material/models/contact.dart';

class PackedooUser extends BaseUserInfo {
  String email;
  bool emailVerified;
  String firstName;
  String lastName;
  String locale;
  String aboutMe;
  String phoneNumber;
  bool phoneVerified;
  bool admin;
  List<String> roles;
  FirebaseUser firebaseUser;

  Contact contact;

  PackedooUser();

  PackedooUser.external({Contact contact}) {
    contact = contact;
  }

  PackedooUser.fromMap(Map<dynamic, dynamic> map)
      : email = map['email'],
        emailVerified = map['emailVerified'] ?? false,
        firstName = map['firstName'],
        lastName = map['lastName'],
        aboutMe = map['aboutMe'] ?? '',
        locale = map['locale'],
        phoneNumber = map['phoneNumber'],
        phoneVerified = map['phoneVerified'] ?? false,
        admin = map['admin'] ?? false,
        roles = map['roles'] != null
            ? List<String>.from(map['roles'])
            : List<String>(),
        super.fromMap(map);
}
