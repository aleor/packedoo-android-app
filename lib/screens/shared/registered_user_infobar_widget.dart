import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:packedoo_app_material/models/base_user_info.dart';
import 'package:packedoo_app_material/services/images.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/styles.dart';

class RegisteredUserInfoBar extends StatefulWidget {
  RegisteredUserInfoBar({@required this.user, this.header});

  final BaseUserInfo user;
  final Widget header;

  @override
  _RegisteredUserInfoBarState createState() => _RegisteredUserInfoBarState();
}

class _RegisteredUserInfoBarState extends State<RegisteredUserInfoBar> {
  final ImageService _imageService = imageService;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.header ?? Container(),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toProfile,
          child: Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10, right: 16),
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: _imageService.getNetworkImageOrPlaceholder(
                          imageUrl: widget.user.photoUrl,
                          placeholder: 'assets/images/default_user.png',
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 2),
                      child: Row(
                        children: <Widget>[
                          Text(widget.user.safeUserName),
                        ],
                      ),
                    ),
                    if (widget.user.rating != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 7),
                        child: Row(
                          children: <Widget>[
                            FlutterRatingBarIndicator(
                              rating: widget.user.rating,
                              itemCount: 5,
                              itemSize: 20.0,
                              fillColor: Styles.kGreenColor,
                              emptyColor: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _toProfile() {
    NavigationService.toRegisteredUserProfile(widget.user.uid);
  }
}
