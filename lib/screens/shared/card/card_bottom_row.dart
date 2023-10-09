import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/base_pack_info.dart';
import 'package:packedoo_app_material/models/price.dart';
import 'package:packedoo_app_material/screens/shared/card/card_price_column.dart';
import 'package:packedoo_app_material/styles.dart';

class CardBottomRow extends StatefulWidget {
  final BasePackInfo basePackInfo;
  final Price price;
  final bool showDeliveryDate;

  const CardBottomRow(
      {Key key, this.basePackInfo, this.price, this.showDeliveryDate = true})
      : super(key: key);

  @override
  _CardBottomRowState createState() => _CardBottomRowState();
}

class _CardBottomRowState extends State<CardBottomRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 12, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (widget.showDeliveryDate)
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${AppLocalizations.of(context).deliveryUntil}: ${widget.basePackInfo.desiredDateDDMMYYY}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Styles.kBlackWithOpacityTextColor,
                      ),
                    ),
                  ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/blue_circle.png',
                        width: 15,
                        height: 15,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 7, right: 7),
                          child: Text(
                            widget.basePackInfo.origin.city,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/red_circle.png',
                        width: 15,
                        height: 15,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 7, right: 7),
                          child: Text(
                            widget.basePackInfo.destination.city,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              children: [CardPriceColumn(price: widget.price)],
            ),
          ),
        ],
      ),
    );
  }
}
