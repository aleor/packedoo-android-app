import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/models/message.dart';
import 'package:packedoo_app_material/screens/chats/message_styles.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/images.dart';

class MessageRow extends StatefulWidget {
  final Deal deal;
  final Message message;

  const MessageRow({Key key, this.deal, this.message}) : super(key: key);

  @override
  _MessageRowState createState() => _MessageRowState();
}

class _MessageRowState extends State<MessageRow> {
  final AuthService _authService = authService;
  final ImageService _imageService = imageService;
  bool _isMy;

  @override
  Widget build(BuildContext context) {
    _isMy = widget.message.senderId == _authService.currentUserId;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Row(
          children: <Widget>[
            if (!_isMy) _getAvatar(),
            if (!_isMy) _getMessage(),
            if (_isMy) _getMyMessage(),
          ],
        ));
  }

  Widget _getAvatar() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 12),
            child: _getAvatarImage(),
          ),
        ],
      ),
    );
  }

  Widget _getAvatarImage() {
    if (widget.message.system) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset('assets/images/packedoo_icon.png',
              width: 40, height: 40));
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: _imageService.getNetworkImageOrPlaceholder(
            imageUrl: _senderOrMoverImageUrl, width: 40, height: 40));
  }

  Widget _getMessage() {
    return Expanded(
      child: Padding(
        padding:
            EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.14),
        child: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: MessageStyles.messageBackgroundColor,
            border: Border.all(
              width: 0.5,
              color: MessageStyles.messageBackgroundColor,
            ),
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 4, right: 20),
                        child: Text(
                          _senderName ?? '',
                          style: MessageStyles.messageSenderNameStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    _getDate(),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 6, left: 6, right: 6),
                  child: Text(
                    widget.message.text ?? '',
                    maxLines: 200,
                    style: MessageStyles.messageTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMyMessage() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
              decoration: BoxDecoration(
                color: MessageStyles.myMessageBackgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 0.5,
                  color: MessageStyles.myMessageBackgroundColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    widget.message.text ?? '',
                    textAlign: TextAlign.left,
                    maxLines: 200,
                    style: MessageStyles.messageTextStyle,
                  ),
                  Text(
                    widget.message.createdDate,
                    style: MessageStyles.myMessageTimestampStyle,
                  ),
                ],
              ),
            ),
            Container(
              child:
                  Text(_hasBeenRead, style: MessageStyles.myMessageStatusStyle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDate() {
    return Container(
      padding: EdgeInsets.only(right: 5),
      alignment: Alignment.topRight,
      child: Text(
        widget.message.createdDate,
        style: MessageStyles.messageTimestampStyle,
      ),
    );
  }

  String get _senderOrMoverImageUrl {
    if (widget.message.senderId == widget.deal.senderId) {
      return widget.deal.sender.photoUrl;
    } else if (widget.message.senderId == widget.deal.mooverId) {
      return widget.deal.moover.photoUrl;
    }

    return '';
  }

  String get _senderName {
    if (widget.message.system) {
      return 'Packedoo';
    } else if (widget.message.senderId == widget.deal.senderId) {
      return widget.deal.sender.safeUserName;
    } else if (widget.message.senderId == widget.deal.mooverId) {
      return widget.deal.moover.safeUserName;
    }

    return '';
  }

  String get _hasBeenRead {
    return widget.message.isNew
        ? AppLocalizations.of(context).sent
        : AppLocalizations.of(context).read;
  }
}
