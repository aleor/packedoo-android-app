import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:packedoo_app_material/models/base_pack_info.dart';
import 'package:packedoo_app_material/models/base_user_info.dart';
import 'package:packedoo_app_material/models/price.dart';

class Deal {
  String id;
  String comment;
  String lotId;
  String mooverId;
  String senderId;
  int status;
  Price price;
  DateTime suggestedDate;
  BasePackInfo baseLotInfo;
  BaseUserInfo moover;
  BaseUserInfo sender;
  int sendersUnread;
  int mooversUnread;
  bool hasMooverReview;
  bool hasSenderReview;

  String get suggestedDateDDMMYYY =>
      DateFormat("d.MM.yyyy").format(suggestedDate);

  Deal.fromMap(Map<String, dynamic> map, String documentId)
      : id = documentId,
        comment = map['comment'] ?? '',
        lotId = map['lotId'],
        mooverId = map['mooverId'],
        senderId = map['senderId'],
        hasMooverReview = map['hasMooverReview'] ?? false,
        hasSenderReview = map['hasSenderReview'] ?? false,
        status = map['status'],
        price = Price.fromMap(map['price']),
        sendersUnread = map['sendersUnread'] ?? 0,
        mooversUnread = map['mooversUnread'] ?? 0,
        suggestedDate = (map['suggestedDate'] as Timestamp).toDate(),
        moover = map['moover'] != null
            ? BaseUserInfo.fromMap(Map<dynamic, dynamic>.from(map['moover']))
            : null,
        sender = map['sender'] != null
            ? BaseUserInfo.fromMap(Map<dynamic, dynamic>.from(map['sender']))
            : null,
        baseLotInfo = map['lot'] != null
            ? BasePackInfo.fromMap(
                Map<dynamic, dynamic>.from(map['lot']), map['lotId'])
            : null;

  Deal(this.lotId, this.comment, this.price, this.suggestedDate);
}
