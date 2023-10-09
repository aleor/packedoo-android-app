import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/screens/my_items/sendings/my_sending_card_item.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/services/lots.dart';
import 'package:packedoo_app_material/services/navigation.dart';

class MySendingsScreen extends StatefulWidget {
  @override
  _MySendingsScreenState createState() => _MySendingsScreenState();
}

class _MySendingsScreenState extends State<MySendingsScreen> {
  final LotsService _lotsService = lotsService;

  List<Pack> _activeItems = [];
  List<Pack> _archivedItems = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _lotsService.getMySends(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CustomCircularIndicator(),
            );

          if (snapshot.data.documents.isEmpty)
            return _noAvailableItemsMessage();

          final packs = List<Pack>.from(snapshot.data.documents.map(
              (document) => Pack.fromMap(document.data, document.documentID)));

          _activeItems = packs
              .where((pack) =>
                  pack.status <= PackConstants.statusIdMap[Status.DELIVERED] ||
                  pack.status == PackConstants.statusIdMap[Status.CONFIRMED] &&
                      !pack.hasSenderReview)
              .toList();

          _archivedItems =
              packs.where((pack) => !_activeItems.contains(pack)).toList();

          return _buildPacksLists();
        },
      ),
    );
  }

  _buildPacksLists() {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) =>
          _expandableListView(index: index),
    );
  }

  Widget _expandableListView({int index}) {
    return index == 0 ? _getActiveItemsList() : _getArchivedItemsList();
  }

  Widget _getActiveItemsList() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: _activeItems
            .map(
              (pack) => MySendingCardItem(
                pack: pack,
                onTapHandler: _routeToDetails,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _getArchivedItemsList() {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 30),
      child: ExpansionTile(
        title: Text(AppLocalizations.of(context).archivedItems),
        children: _archivedItems
            .map(
              (pack) => MySendingCardItem(
                pack: pack,
                onTapHandler: _routeToDetails,
              ),
            )
            .toList(),
      ),
    );
  }

  _noAvailableItemsMessage() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          AppLocalizations.of(context).noItemsToSend,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  _routeToDetails(Pack pack) {
    final status = PackConstants.idStatusMap[pack.status];

    Function exec;

    switch (status) {
      case Status.PENDING:
        exec = () => NavigationService.toMySendingsOffers(pack);
        break;
      case Status.ACCEPTED:
        exec = () => NavigationService.toAcceptedDeal(pack);
        break;
      case Status.IN_PROGRESS:
        exec = () => NavigationService.toInDeliveryDeal(pack);
        break;
      case Status.CONFIRMED:
        exec = () => NavigationService.toDealReview(pack.id, isSender: true);
        break;
      default:
        exec = null;
    }

    exec?.call();
  }
}
