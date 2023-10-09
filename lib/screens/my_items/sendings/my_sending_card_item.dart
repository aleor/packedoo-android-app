import 'package:flutter/material.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/screens/shared/card/card_bottom_row.dart';
import 'package:packedoo_app_material/screens/shared/card/card_info_column.dart';
import 'package:packedoo_app_material/screens/shared/card/card_photo_column.dart';

class MySendingCardItem extends StatefulWidget {
  final Pack pack;
  final Function onTapHandler;

  const MySendingCardItem({Key key, this.pack, this.onTapHandler})
      : super(key: key);

  @override
  _MySendingCardItemState createState() => _MySendingCardItemState();
}

class _MySendingCardItemState extends State<MySendingCardItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTapHandler(widget.pack),
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
                  CardPhotoColumn(photos: widget.pack.photos),
                  Expanded(
                      child: CardInfoColumn(
                    basePackInfo: widget.pack,
                    pendingCount: widget.pack.pendingCount,
                  )),
                ],
              ),
              Divider(height: 1, thickness: 1),
              CardBottomRow(
                basePackInfo: widget.pack,
                price: widget.pack.price,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
