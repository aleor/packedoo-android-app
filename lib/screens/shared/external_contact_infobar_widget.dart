import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/contact.dart';
import 'package:packedoo_app_material/services/images.dart';

class ExternalContactInfoBar extends StatefulWidget {
  ExternalContactInfoBar(
      {@required this.contact,
      this.handler,
      this.icon = Icons.phone,
      this.phoneHidden = false});

  final Contact contact;
  final IconData icon;
  final Function handler;
  final bool phoneHidden;

  @override
  _ExternalContactInfoBarState createState() => _ExternalContactInfoBarState();
}

class _ExternalContactInfoBarState extends State<ExternalContactInfoBar> {
  final ImageService _imageService = imageService;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _externalContactRow(),
    );
  }

  Row _externalContactRow() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 22, top: 10),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: _imageService.getNetworkImageOrPlaceholder(
                  imageUrl: null,
                  placeholder: 'assets/images/default_user.png',
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('${widget.contact.name}'),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Text(_getPhoneText()),
                  ],
                ),
              )
            ],
          ),
        ),
        if (!widget.phoneHidden)
          GestureDetector(
            onTap: widget.handler ?? () {},
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: <Widget>[
                Container(
                  child: Container(
                    padding: EdgeInsets.only(right: 16, bottom: 10),
                    child: Icon(
                      widget.icon,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ),
                )
              ],
            ),
          )
      ],
    );
  }

  String _getPhoneText() {
    return (!widget.phoneHidden)
        ? '${widget.contact.phoneNumber}'
        : AppLocalizations.of(context).phoneNumberHidden;
  }
}
