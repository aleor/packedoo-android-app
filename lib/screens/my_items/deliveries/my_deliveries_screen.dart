import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/screens/my_items/deliveries/my_delivery_card_item.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/services/deals.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/navigation.dart';

class MyDeliveriesScreen extends StatefulWidget {
  @override
  _MyDeliveriesScreenState createState() => _MyDeliveriesScreenState();
}

class _MyDeliveriesScreenState extends State<MyDeliveriesScreen> {
  final DealsService _dealsService = dealsService;
  List<Deal> _activeItems = [];
  List<Deal> _archivedItems = [];

  @override
  void initState() {
    GoogleAnalytics().setScreen('my_deliveries');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _dealsService.getMyDeliveries(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CustomCircularIndicator(),
            );

          if (snapshot.data.documents.isEmpty)
            return _noAvailableItemsMessage();

          final deals = List<Deal>.from(snapshot.data.documents.map(
              (document) => Deal.fromMap(document.data, document.documentID)));

          _activeItems = deals
              .where((deal) =>
                  deal.status < PackConstants.statusIdMap[Status.DELIVERED] ||
                  (deal.status == PackConstants.statusIdMap[Status.CONFIRMED] &&
                      !deal.hasMooverReview))
              .toList();

          _archivedItems =
              deals.where((deal) => !_activeItems.contains(deal)).toList();

          return _buildDealsLists();
        },
      ),
    );
  }

  _buildDealsLists() {
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
              (deal) => MyDeliveryCardItem(
                deal: deal,
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
              (deal) => MyDeliveryCardItem(
                deal: deal,
                onTapHandler: _routeToDetails,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _noAvailableItemsMessage() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          AppLocalizations.of(context).noItemsToDeliver,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  _routeToDetails(Deal deal) {
    final status = PackConstants.idStatusMap[deal.status];

    Function exec;
    switch (status) {
      case Status.PENDING:
        exec = () => NavigationService.toDealMessages(deal.id);
        break;
      case Status.ACCEPTED:
      case Status.IN_PROGRESS:
        exec = () => NavigationService.toActiveDelivery(deal.id);
        break;
      case Status.CONFIRMED:
        exec = () => NavigationService.toDealReview(deal.baseLotInfo.id,
            isSender: false);
        break;
      case Status.CANCELED:
      case Status.DECLINED:
        exec = () => NavigationService.toInactiveDealMessages(deal);
        break;
      default:
        exec = null;
    }

    exec?.call();
  }
}
