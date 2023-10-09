import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/services/images.dart';
import 'package:packedoo_app_material/services/messages.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/styles.dart';

class DealOfferRow extends StatefulWidget {
  final BuildContext parentContext;
  final Deal deal;
  final bool isLast;

  const DealOfferRow({Key key, this.parentContext, this.deal, this.isLast})
      : super(key: key);

  @override
  _DealOfferRowState createState() => _DealOfferRowState();
}

class _DealOfferRowState extends State<DealOfferRow> {
  final ImageService _imageService = imageService;
  final MessagesService _messagesService = messagesService;

  String _latestMessage;

  @override
  void initState() {
    _getLatestMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toDealChat,
      child: Container(
        child: Column(
          children: <Widget>[
            Divider(height: 2),
            _offerTermsRow(),
            widget.isLast ? Divider(height: 2) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _offerTermsRow() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          _photoColumn(),
          _mainColumn(),
        ],
      ),
    );
  }

  Widget _photoColumn() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: _getAvatar(),
          ),
        ],
      ),
    );
  }

  Widget _mainColumn() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: <Widget>[
            _nameAndRating(),
            _terms(),
            _message(),
          ],
        ),
      ),
    );
  }

  Widget _getAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: _imageService.getNetworkImageOrPlaceholder(
          imageUrl: widget.deal.moover.photoUrl, width: 50, height: 50),
    );
  }

  Widget _nameAndRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Text(
            widget.deal.moover.displayName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
        FlutterRatingBarIndicator(
          rating: widget.deal.moover.rating ?? 0,
          itemCount: 5,
          itemSize: 15,
          fillColor: Styles.kGreenColor,
          emptyColor: Colors.grey,
        )
      ],
    );
  }

  Widget _terms() {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              _getTerms(),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Styles.kGreyTextColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _message() {
    return Container(
      padding: EdgeInsets.only(top: 6),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              _latestMessage ?? '...',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Styles.kGreyTextColor),
            ),
          ),
        ],
      ),
    );
  }

  String _getTerms() {
    return '${AppLocalizations.of(context).willDeliverUntil} ${widget.deal.suggestedDateDDMMYYY}, ' +
        '${AppLocalizations.of(context).forSmall} ${widget.deal.price.formattedValue} ${widget.deal.price.currency}';
  }

  _getLatestMessage() async {
    var _message =
        await _messagesService.getLatestMessageForDeal(widget.deal.id);

    final _text = _message?.text ?? widget.deal.comment;

    setState(() {
      _latestMessage = _text;
    });
  }

  _toDealChat() {
    NavigationService.toDealMessages(widget.deal.id);
  }
}
