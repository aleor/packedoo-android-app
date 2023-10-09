import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/models/reviewer.dart';

class Review {
  String dealId;
  bool inTime;
  bool isDelivered;
  bool isFriendly;
  bool isIntegrity;
  String lotId;
  double rating;
  String revieweeId;
  String reviewerId;
  String text;
  DateTime createdOn;
  Pack lot;
  Reviewer reviewer;

  Review.fromMap(Map<String, dynamic> map) {
    dealId = map['dealId'];
    inTime = map['inTime'];
    isDelivered = map['isDelivered'];
    isFriendly = map['isFriendly'];
    isIntegrity = map['isIntegrity'];
    lotId = map['lotId'];
    rating = map['rating'] != null ? double.parse(map['rating'].toString()) : 0;
    revieweeId = map['revieweeId'];
    reviewerId = map['reviewerId'];
    text = map['text'];
    createdOn = map['createdOn'] != null
        ? (map['createdOn'] as Timestamp).toDate()
        : null;
    lot = map['lot'] != null
        ? Pack.fromMap(Map<String, dynamic>.from(map['lot']), map['lotId'])
        : null;
    reviewer =
        map['reviewer'] != null ? Reviewer.fromMap(map['reviewer']) : null;
  }

  Review(
      {this.dealId,
      this.lotId,
      this.rating,
      this.revieweeId,
      this.inTime,
      this.isDelivered,
      this.isFriendly,
      this.isIntegrity,
      this.text});

  Map<String, dynamic> toMap() {
    return {
      'dealId': this.dealId,
      'inTime': this.inTime,
      'isDelivered': this.isDelivered,
      'isFriendly': this.isFriendly,
      'isIntegrity': this.isIntegrity,
      'lotId': this.lotId,
      'rating': this.rating,
      'revieweeId': this.revieweeId,
      'reviewerId': this.reviewerId,
      'createdOn': this.createdOn,
      'text': this.text
    };
  }
}
