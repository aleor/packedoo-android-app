import 'package:flutter/material.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/screens/my_items/sendings/accepted_deal_screen.dart';

class InDeliveryDealScreen extends StatefulWidget {
  final Pack pack;

  const InDeliveryDealScreen({Key key, this.pack}) : super(key: key);

  @override
  _InDeliveryDealScreenState createState() => _InDeliveryDealScreenState();
}

class _InDeliveryDealScreenState extends State<InDeliveryDealScreen> {
  @override
  Widget build(BuildContext context) {
    return AcceptedDealScreen(
      lot: widget.pack,
      inDelivery: true,
    );
  }
}
