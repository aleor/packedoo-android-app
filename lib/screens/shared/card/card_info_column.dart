import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/localizable_constants.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/base_pack_info.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/styles.dart';

class CardInfoColumn extends StatefulWidget {
  final BasePackInfo basePackInfo;
  final bool showStatus;
  final Deal deal;
  final int pendingCount;

  const CardInfoColumn(
      {Key key,
      @required this.basePackInfo,
      this.pendingCount,
      this.deal,
      this.showStatus = true})
      : super(key: key);

  @override
  _CardInfoColumnState createState() => _CardInfoColumnState();
}

class _CardInfoColumnState extends State<CardInfoColumn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              widget.basePackInfo.name,
              style: TextStyle(fontSize: 18),
              overflow: widget.basePackInfo.name.length > 60
                  ? TextOverflow.ellipsis
                  : TextOverflow.clip,
            ),
          ),
          if (widget.showStatus) _statusWithCounter(),
        ],
      ),
    );
  }

  Widget _statusWithCounter() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5, right: 18),
          child: Text(
            _getStatusName(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Styles.kBlackWithOpacityTextColor),
          ),
        ),
        if (PackConstants.statusIdMap[Status.PENDING] ==
                widget.basePackInfo.status &&
            widget.pendingCount != null &&
            widget.pendingCount > 0)
          Positioned(
            right: 0,
            bottom: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Container(
                padding: EdgeInsets.all(2),
                child: Text(
                  ' ${widget.pendingCount} ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
                color: Color(0xffee5d69),
              ),
            ),
          ),
      ],
    );
  }

  String _getStatusName() {
    if (widget.deal != null &&
        widget.deal.status == PackConstants.statusIdMap[Status.PENDING]) {
      return AppLocalizations.of(context).pendingDealStatus;
    }

    return LocalizableConstants.getStatusName(
        context: context, statusId: _statusId);
  }

  int get _statusId =>
      widget.deal != null ? widget.deal.status : widget.basePackInfo.status;
}
