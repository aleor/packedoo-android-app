import 'package:flutter/material.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/screens/shared/card/card_bottom_row.dart';
import 'package:packedoo_app_material/screens/shared/card/card_info_column.dart';
import 'package:packedoo_app_material/screens/shared/card/card_photo_column.dart';

class MyDeliveryCardItem extends StatefulWidget {
  final Deal deal;
  final Function onTapHandler;

  const MyDeliveryCardItem({Key key, this.deal, this.onTapHandler})
      : super(key: key);

  @override
  _MyDeliveryCardItemState createState() => _MyDeliveryCardItemState();
}

class _MyDeliveryCardItemState extends State<MyDeliveryCardItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTapHandler(widget.deal),
      child: Container(
        padding: EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
        child: Card(
          elevation: 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CardPhotoColumn(photos: widget.deal.baseLotInfo.photos),
                  Expanded(
                      child: CardInfoColumn(
                    basePackInfo: widget.deal.baseLotInfo,
                    deal: widget.deal,
                  )),
                ],
              ),
              Divider(height: 1, thickness: 1),
              CardBottomRow(
                basePackInfo: widget.deal.baseLotInfo,
                price: widget.deal.price,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
