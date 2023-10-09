import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/new_pack.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';

final LotsService lotsService = LotsService();

class LotsService {
  final _authService = authService;

  Stream<QuerySnapshot> getLotsWithStatus(Status status) {
    return Firestore.instance
        .collection('lots')
        .where('status', isEqualTo: PackConstants.statusIdMap[status])
        .orderBy('createdOn', descending: true)
        .snapshots();
  }

  Future<List<Pack>> fetchLotsWithStatus(Status status) async {
    final _query = await Firestore.instance
        .collection('lots')
        .where('status', isEqualTo: PackConstants.statusIdMap[status])
        .orderBy('createdOn', descending: true)
        .getDocuments();

    if (_query.documents.isEmpty) return List<Pack>();

    return List<Pack>.from(_query.documents
        .map((document) => Pack.fromMap(document.data, document.documentID)));
  }

  Stream<QuerySnapshot> getMySends() {
    return Firestore.instance
        .collection('lots')
        .where('uid', isEqualTo: _authService.currentUserId)
        .orderBy('status', descending: false)
        .snapshots();
  }

  Future<Pack> getPack(String packId) async {
    final documentSnapshot =
        await Firestore.instance.collection('lots').document(packId).get();

    return documentSnapshot.exists
        ? Pack.fromMap(documentSnapshot.data, packId)
        : null;
  }

  Future<DocumentReference> addPack(NewPack pack) async {
    GoogleAnalytics().lotCreate();

    final packData = pack.toMap();
    final ref = await Firestore.instance.collection('lots').add(packData);

    return ref;
  }

  Future remove(String packId) async {
    return await Firestore.instance
        .collection('lots')
        .document(packId)
        .delete();
  }
}
