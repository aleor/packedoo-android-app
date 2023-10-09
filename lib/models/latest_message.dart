import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:packedoo_app_material/models/base_pack_info.dart';
import 'package:packedoo_app_material/models/base_user_info.dart';

class LatestMessage {
  String id;
  String chatId;
  String chatType;
  DateTime createdOn;
  String dealId;
  BasePackInfo lot;
  BaseUserInfo sender;
  BaseUserInfo party;
  String messageId;
  bool notified;
  bool isNew;
  String senderId;
  bool system;
  String text;
  int dealStatus;
  int unreadCount;

  String get createdDate {
    final now = DateTime.now();
    return DateTime(createdOn.year, createdOn.month, createdOn.day) ==
            DateTime(now.year, now.month, now.day)
        ? DateFormat('HH:mm').format(createdOn)
        : DateFormat('MMM dd, HH:mm').format(createdOn);
  }

  LatestMessage.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'],
        chatId = map['chatId'],
        chatType = map['chatType'],
        dealId = map['dealId'],
        notified = map['notified'],
        isNew = map['new'],
        senderId = map['senderId'],
        system = map['system'],
        text = map['text'],
        dealStatus = map['dealStatus'],
        unreadCount = map['unreadCount'],
        lot = map['lot'] != null
            ? BasePackInfo.fromMap(map['lot'], map['dealId'])
            : null,
        sender =
            map['sender'] != null ? BaseUserInfo.fromMap(map['sender']) : null,
        party =
            map['party'] != null ? BaseUserInfo.fromMap(map['party']) : null,
        createdOn = map['createdOn'] != null
            ? (map['createdOn'] as Timestamp).toDate()
            : null;
}
