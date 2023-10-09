import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/localizable_constants.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/screens/shared/card/card_bottom_row.dart';
import 'package:packedoo_app_material/screens/shared/card/card_photo_column.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/deals.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/styles.dart';

class LotCardItem extends StatefulWidget {
  final Pack pack;

  const LotCardItem({Key key, this.pack}) : super(key: key);

  @override
  _LotCardItemState createState() => _LotCardItemState();
}

class _LotCardItemState extends State<LotCardItem> {
  final AuthService _authService = authService;
  final UIService _uiService = uiService;
  final DealsService _dealsService = dealsService;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onLotSelected,
      child: Container(
        padding: EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
        child: Card(
          elevation: 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CardPhotoColumn(photos: widget.pack.photos),
                  Expanded(child: _infoColumn()),
                ],
              ),
              Divider(height: 1, thickness: 1),
              CardBottomRow(
                  basePackInfo: widget.pack,
                  price: widget.pack.price,
                  showDeliveryDate: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoColumn() {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              widget.pack.name,
              style: TextStyle(fontSize: 18),
              overflow: widget.pack.name.length > 60
                  ? TextOverflow.ellipsis
                  : TextOverflow.clip,
            ),
          ),
          // TODO: null date handler
          // Container(
          //   padding: const EdgeInsets.only(top: 5, bottom: 5),
          //   child: Text(
          //     '${AppLocalizations.of(context).deliveryUntil}: ${widget.pack.desiredDateDDMMYYY}',
          //     style: TextStyle(
          //       fontSize: 14,
          //       color: Styles.kBlackWithOpacityTextColor,
          //     ),
          //   ),
          // ),
          Container(
            // restore bottom to 8, top to 0
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Text(
              '${AppLocalizations.of(context).size}: $_getSize',
              style: TextStyle(color: Styles.kBlackWithOpacityTextColor),
            ),
          ),
        ],
      ),
    );
  }

  _onLotSelected() async {
    _uiService.showActivityIndicator(context);

    Deal _pendingDeal;
    try {
      _pendingDeal = await _dealsService.getMyPendingDealFor(widget.pack.id);
    } catch (e) {
      _uiService.hideActivityIndicator(context, true);
      await _uiService.showInfoDialog(
          context,
          AppLocalizations.of(context).error,
          AppLocalizations.of(context).cantMakeRequest);
      return;
    }
    _uiService.hideActivityIndicator(context, true);

    _pendingDeal != null
        ? _toPendingDealScreen(_pendingDeal)
        : _toViewLotScreen();
  }

  _toViewLotScreen() {
    NavigationService.toLotViewScreen(
      lotId: widget.pack.id,
      isMy: _authService.currentUserId == widget.pack.uid,
    );
  }

  get _getSize => LocalizableConstants.getLotSize(
      sizeId: widget.pack.sizeId, context: context);

  _toPendingDealScreen(Deal deal) {
    NavigationService.toPendingDealScreen(deal);
  }
}
