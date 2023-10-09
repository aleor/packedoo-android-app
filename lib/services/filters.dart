import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:packedoo_app_material/models/filter.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/callable.dart';
import 'package:quiver/strings.dart';

FiltersService filtersService = FiltersService();

class FiltersService {
  static final _authService = authService;

  CollectionReference get _filtersStore => Firestore.instance
      .collection('users/${_authService.currentUserId}/filters');

  Future<List<Pack>> apply({Filter filter}) async {
    final HttpsCallable costCallable = Callable.instance.getHttpsCallable(
      functionName: 'search',
    );

    List<Pack> packs;

    try {
      final response = await costCallable.call(filter.toMap());

      packs = List<Pack>.from(response.data.map((document) =>
          Pack.fromMap(Map<String, dynamic>.from(document), document['id'])));
    } catch (e) {}

    return packs;
  }

  Future<String> save({Filter filter}) async {
    filter.uid = _authService.currentUserId;

    return isEmpty(filter.id) ? await _create(filter) : await _update(filter);
  }

  Stream<List<Filter>> getAll() {
    StreamTransformer<QuerySnapshot, List<Filter>> _streamTransformer =
        StreamTransformer.fromHandlers(handleData:
            (QuerySnapshot snapshot, EventSink<List<Filter>> filters) {
      snapshot.documents.isEmpty
          ? filters.add([])
          : filters.add(List.from(snapshot.documents
              .map((d) => Filter.fromMap(d.data, d.documentID))));
    });

    return _filtersStore.snapshots().transform(_streamTransformer);
  }

  Future delete({String filterId}) {
    if (filterId == null) return Future.value(null);

    return _filtersStore.document(filterId).delete();
  }

  Future<String> _create(Filter filter) async {
    final docRef = await _filtersStore.add(filter.toMap());

    return docRef.documentID;
  }

  Future<String> _update(Filter filter) async {
    await _filtersStore
        .document(filter.id)
        .setData(filter.toMap(), merge: true);

    return filter.id;
  }
}
