import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:packedoo_app_material/models/latest_message.dart';
import 'package:packedoo_app_material/models/message.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';

final MessagesService messagesService = MessagesService();

class MessagesService {
  final _authService = authService;

  Stream<QuerySnapshot> getMessagesForDeal(String dealId) {
    return Firestore.instance
        .collection('deals/$dealId/messages')
        .orderBy('createdOn', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getMyLastMessages() {
    return Firestore.instance
        .collection('users/${_authService.currentUserId}/lastMessages')
        .orderBy('createdOn', descending: true)
        .snapshots();
  }

  Future<LatestMessage> getLatestMessageForDeal(String dealId) async {
    final _document = await Firestore.instance
        .collection('users/${_authService.currentUserId}/lastMessages')
        .document(dealId)
        .get();

    return _document.exists ? LatestMessage.fromMap(_document.data) : null;
  }

  Stream<QuerySnapshot> getUserMessages() {
    return Firestore.instance
        .collection('users/${_authService.currentUserId}/messages')
        .orderBy('createdOn', descending: false)
        .snapshots();
  }

  Future<DocumentReference> sendMessage(Message message) {
    GoogleAnalytics().sendMessage();

    return Firestore.instance
        .collection('deals/${message.dealId}/messages')
        .add({
      'dealId': message.dealId,
      'senderId': _authService.currentUserId,
      'recipientId': message.recipientId,
      'text': message.text,
      'createdOn': DateTime.now(),
      'notified': false,
      'new': true,
      'system': false,
      'push': true
    });
  }

  Future<DocumentReference> sendToPackedoo(String message) {
    GoogleAnalytics().sendMessage();

    return Firestore.instance
        .collection('users/${_authService.currentUserId}/messages')
        .add({
      'senderId': _authService.currentUserId,
      'text': message,
      'createdOn': DateTime.now(),
      'notified': false,
      'new': true,
      'system': false,
      'push': true
    });
  }

  Future markAsReadForDeal(String dealId) async {
    var _allUnreadDealMessages = await Firestore.instance
        .collection('deals/$dealId/messages')
        .where('recipientId', isEqualTo: _authService.currentUserId)
        .where('new', isEqualTo: true)
        .getDocuments();

    if (_allUnreadDealMessages.documents.isEmpty) return;

    _allUnreadDealMessages.documents
        .forEach((d) => {_markSeen(dealId, d.documentID)});
  }

  Future markAsReadForInternalChat() async {
    var _allUnreadInternalMessages = await Firestore.instance
        .collection('users/${_authService.currentUserId}/messages')
        .where('recipientId', isEqualTo: _authService.currentUserId)
        .where('new', isEqualTo: true)
        .getDocuments();

    if (_allUnreadInternalMessages.documents.isEmpty) return;

    _allUnreadInternalMessages.documents
        .forEach((d) => {_markSeen(null, d.documentID, fromPackedoo: true)});
  }

  _markSeen(String dealId, String documentId, {bool fromPackedoo = false}) {
    final _collection = fromPackedoo
        ? 'users/${_authService.currentUserId}/messages'
        : 'deals/$dealId/messages';

    Firestore.instance
        .collection(_collection)
        .document(documentId)
        .setData({'new': false, 'notified': true}, merge: true);
  }
}
