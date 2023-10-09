import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/screens/my_items/sendings/deal_offer_row.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/screens/shared/view_lot_icon_button_widget.dart';
import 'package:packedoo_app_material/services/deals.dart';

class MySendingsOffersScreen extends StatefulWidget {
  final Pack pack;

  const MySendingsOffersScreen({Key key, this.pack}) : super(key: key);

  @override
  _MySendingsOffersScreenState createState() => _MySendingsOffersScreenState();
}

class _MySendingsOffersScreenState extends State<MySendingsOffersScreen> {
  final DealsService _dealsService = dealsService;
  List<Deal> _deals;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _dealsService.getDealsFor(widget.pack.id, Status.PENDING),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.pack.name),
              actions: <Widget>[
                ViewLotIconButton(
                  lotId: widget.pack.id,
                  userId: widget.pack.sender.uid,
                )
              ],
            ),
            body: _buildBody(snapshot),
          );
        });
  }

  Widget _buildBody(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) return Center(child: CustomCircularIndicator());

    _deals = List<Deal>.from(snapshot.data.documents
        .map((document) => Deal.fromMap(document.data, document.documentID)));

    return _buildDealsList();
  }

  _buildDealsList() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 15, left: 16, right: 16),
            child: Text(
              _getOffersCount(),
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _deals.length,
              itemBuilder: (BuildContext context, int index) {
                return DealOfferRow(
                  parentContext: context,
                  deal: _deals[index],
                  isLast: _deals.length == index + 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getOffersCount() {
    return (_deals.length == 0)
        ? AppLocalizations.of(context).youHaveNoOffersYet
        : AppLocalizations.of(context).youHave +
            ' ${_deals.length} ${_getPlural(_deals.length)}';
  }

  String _getPlural(int count) {
    if (count == 1) return AppLocalizations.of(context).newOffer;

    if (count > 1 && count <= 4)
      return AppLocalizations.of(context).oneToFourNewOffers;

    return AppLocalizations.of(context).newOffers;
  }
}
