import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Message {
  DateTime createdOn;
  String dealId;
  bool notified;
  bool isNew;
  String recipientId;
  String senderId;
  bool system;
  String text;

  String get createdDate {
    final now = DateTime.now();
    return DateTime(createdOn.year, createdOn.month, createdOn.day) ==
            DateTime(now.year, now.month, now.day)
        ? DateFormat('HH:mm').format(createdOn)
        : DateFormat('MMM dd, HH:mm').format(createdOn);
  }

  Message.fromMap(Map<String, dynamic> map)
      : dealId = map['dealId'],
        notified = map['notified'],
        isNew = map['new'],
        recipientId = map['recipientId'],
        senderId = map['senderId'],
        system = map['system'],
        text = map['text'],
        createdOn = map['createdOn'] != null
            ? (map['createdOn'] as Timestamp).toDate()
            : null;

  Message.latestFromDeal(Map<dynamic, dynamic> map)
      : createdOn = map['createdOn'] != null
            ? (map['createdOn'] as Timestamp).toDate()
            : null,
        system = map['system'],
        text = map['text'] ?? '';

  Message(this.dealId, this.recipientId, this.text);
}
