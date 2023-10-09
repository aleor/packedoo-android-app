import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/latest_message.dart';
import 'package:packedoo_app_material/screens/chats/message_styles.dart';
import 'package:packedoo_app_material/services/images.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';

class DealLatestMessageRow extends StatefulWidget {
  final bool isLast;
  final Function onTapHandler;
  final LatestMessage latestMessage;
  final bool fromPackedoo;

  const DealLatestMessageRow(
      {Key key,
      @required this.latestMessage,
      this.isLast,
      this.onTapHandler,
      this.fromPackedoo = false})
      : super(key: key);

  @override
  _DealLatestMessageRowState createState() => _DealLatestMessageRowState();
}

class _DealLatestMessageRowState extends State<DealLatestMessageRow> {
  ImageService _imageService = imageService;

  @override
  Widget build(BuildContext context) {
    final row = SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _getHandler,
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildLeftColumn(),
              _buildCenter(),
              _buildRightColumn(),
            ],
          ),
        ),
      ),
    );

    return Column(
      children: <Widget>[
        Divider(height: 2),
        row,
        widget.isLast ? Divider(height: 2) : Container(),
      ],
    );
  }

  Widget _buildLeftColumn() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 12),
            child: _getAvatar(),
          ),
        ],
      ),
    );
  }

  Widget _getAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: _getAvatarImage(),
    );
  }

  Widget _buildCenter() {
    return Expanded(
      flex: 11,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              _name,
              style: MessageStyles.dealNameStyle,
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              _latestMessageText,
              style: MessageStyles.dealLatestMessageStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Text(
              widget.latestMessage?.createdDate ?? '',
              style: MessageStyles.dealLatestMessageTimeStampStyle,
            ),
          ),
          if (widget.latestMessage.unreadCount != 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Styles.kGreenColor,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  child: Text(
                    widget.latestMessage.unreadCount.toString(),
                    style: MessageStyles.dealUnreadsCountStyle,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  _getHandler() {
    final _id = widget.fromPackedoo ? null : widget.latestMessage.dealId;

    return widget.onTapHandler(_id, fromPackedoo: widget.fromPackedoo);
  }

  String get _name => widget.fromPackedoo
      ? AppLocalizations.of(context).chatWithPackedoo
      : widget.latestMessage.lot.name;

  Widget _getAvatarImage() {
    if (widget.fromPackedoo) {
      return Image.asset('assets/images/packedoo_icon.png',
          width: 40, height: 40);
    }

    return _imageService.getNetworkImageOrPlaceholder(
        imageUrl: widget.latestMessage.party?.photoUrl, width: 40, height: 40);
  }

  String get _latestMessageText => !isEmpty(widget.latestMessage?.text)
      ? widget.latestMessage.text
      : widget.fromPackedoo ? AppLocalizations.of(context).askUsAnything : '';
}
