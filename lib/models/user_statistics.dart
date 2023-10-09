import 'package:cloud_firestore/cloud_firestore.dart';

class UserStatistics {
  String aboutMe;
  int delivered;
  String displayName;
  bool emailVerified;
  bool phoneVerified;
  String photoURL;
  double rating;
  DateTime registeredOn;
  int reviewCount;
  int sent;
  double totalRating;

  UserStatistics.fromMap(Map<dynamic, dynamic> map)
      : displayName = map['displayName'] ?? '',
        aboutMe = map['aboutMe'] ?? '',
        emailVerified = map['emailVerified'] ?? false,
        delivered = map['delivered'] ?? 0,
        sent = map['sent'] ?? 0,
        reviewCount = map['reviewCount'] ?? 0,
        registeredOn = (map['registeredOn'] as Timestamp).toDate(),
        phoneVerified = map['phoneVerified'] ?? false,
        photoURL = map['photoURL'],
        rating =
            map['rating'] != null ? double.parse(map['rating'].toString()) : 0,
        totalRating = map['totalRating'] != null
            ? double.parse(map['totalRating'].toString())
            : 0;
}
