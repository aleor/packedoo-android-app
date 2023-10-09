import 'package:flutter/material.dart';
import 'package:packedoo_app_material/models/price.dart';

class CardPriceColumn extends StatefulWidget {
  final Price price;

  const CardPriceColumn({Key key, this.price}) : super(key: key);

  @override
  _CardPriceColumnState createState() => _CardPriceColumnState();
}

class _CardPriceColumnState extends State<CardPriceColumn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '${widget.price.formattedValue} $_currency',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  // TODO: currency shouldn't be null
  String get _currency => widget.price.currency ?? 'RUB';
}
