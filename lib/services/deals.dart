import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';

final DealsService dealsService = DealsService();

class DealsService {
  final _authService = authService;

  Future<String> offerDeal(Deal deal) async {
    GoogleAnalytics().dealApply();

    var ref = await Firestore.instance.collection('deals').add({
      'mooverId': _authService.currentUserId,
      'lotId': deal.lotId,
      'comment': deal.comment,
      'price': {'value': deal.price.value, 'currency': deal.price.currency},
      'suggestedDate': deal.suggestedDate
    });

    return ref.documentID;
  }

  Future<List<DocumentSnapshot>> getMyActiveDealsFor(String documentId) async {
    final querySnapshot = await Firestore.instance
        .collection('deals')
        .where('lotId', isEqualTo: documentId)
        .where(
          'mooverId',
          isEqualTo: _authService.currentUserId,
        )
        .where('status', isLessThan: PackConstants.statusIdMap[Status.CANCELED])
        .getDocuments();

    return querySnapshot.documents;
  }

  Future<Deal> getMyPendingDealFor(String documentId) async {
    final querySnapshot = await Firestore.instance
        .collection('deals')
        .where('lotId', isEqualTo: documentId)
        .where('mooverId', isEqualTo: _authService.currentUserId)
        .where('status', isEqualTo: PackConstants.statusIdMap[Status.PENDING])
        .getDocuments();

    var _pendingDeal = querySnapshot.documents.isNotEmpty
        ? Deal.fromMap(querySnapshot.documents.first.data,
            querySnapshot.documents.first.documentID)
        : null;

    return _pendingDeal;
  }

  Stream<QuerySnapshot> getMyDeliveries() {
    return Firestore.instance
        .collection('deals')
        .where('mooverId', isEqualTo: _authService.currentUserId)
        .orderBy('status', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getMyDeals() {
    return Firestore.instance
        .collection('deals')
        .where('parties', arrayContains: _authService.currentUserId)
        .snapshots();
  }

  Stream<QuerySnapshot> getDealsFor(String documentId, Status status) {
    return Firestore.instance
        .collection('deals')
        .where('senderId', isEqualTo: _authService.currentUserId)
        .where('lotId', isEqualTo: documentId)
        .where('status', isEqualTo: PackConstants.statusIdMap[status])
        .snapshots();
  }

  Future<Deal> getDeal(String dealId) async {
    var documentSnapshot;
    try {
      documentSnapshot =
          await Firestore.instance.collection('deals').document(dealId).get();
    } catch (e) {}

    return (documentSnapshot != null) && (documentSnapshot.exists)
        ? Deal.fromMap(documentSnapshot.data, dealId)
        : null;
  }

  Stream<Deal> watchDeal(String dealId) {
    return Firestore.instance
        .collection('deals')
        .document(dealId)
        .snapshots()
        .map((s) => Deal.fromMap(s.data, s.documentID));
  }

  Future<Deal> getDealFor(String lotId, Status status,
      {bool isSender = true}) async {
    final query = await Firestore.instance
        .collection('deals')
        .where('lotId', isEqualTo: lotId)
        .where(isSender ? 'senderId' : 'mooverId',
            isEqualTo: _authService.currentUserId)
        .where('status', isEqualTo: PackConstants.statusIdMap[status])
        .getDocuments();

    return query.documents.isNotEmpty
        ? Deal.fromMap(
            query.documents.first.data, query.documents.first.documentID)
        : null;
  }
}
