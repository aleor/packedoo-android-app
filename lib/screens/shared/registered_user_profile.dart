import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/user_statistics.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/services/images.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/users.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';

class RegisteredUserProfile extends StatefulWidget {
  final String userId;

  const RegisteredUserProfile({Key key, @required this.userId})
      : super(key: key);

  @override
  _RegisteredUserProfileState createState() => _RegisteredUserProfileState();
}

class _RegisteredUserProfileState extends State<RegisteredUserProfile> {
  ImageService _imageService = imageService;
  UsersService _usersService = usersService;

  UserStatistics _userStats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).aboutUser),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
        future: _usersService.getUserStats(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            return Center(child: CustomCircularIndicator());
          }

          _userStats = snapshot.data;

          return _buildProfilePage();
        });
  }

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _photo(),
              _name(),
              _rating(),
              _about(),
              Divider(),
              _userInfo(),
              Divider(),
              _reviews(),
              Divider(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _photo() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 25),
      child: Container(
        height: 120,
        width: 120,
        child: _getUserAvatar(),
      ),
    );
  }

  Widget _name() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20),
      child: Text(
        _userStats.displayName ?? AppLocalizations.of(context).nameNotDefined,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _rating() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10),
      child: FlutterRatingBarIndicator(
        rating: _userStats.rating ?? 0,
        itemCount: 5,
        itemSize: 25,
        fillColor: Styles.kGreenColor,
        emptyColor: Colors.grey,
      ),
    );
  }

  Widget _about() {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).aboutMyself,
            style: TextStyle(color: Styles.kGreenColor),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(isEmpty(_userStats.aboutMe)
                ? AppLocalizations.of(context).noAdditionalDescription
                : _userStats.aboutMe),
          ),
        ],
      ),
    );
  }

  Widget _getUserAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(90),
      child: _imageService.getNetworkImageOrPlaceholder(
        imageUrl: _userStats?.photoURL ?? '',
        placeholder: 'assets/images/default_user.png',
      ),
    );
  }

  Widget _userInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(AppLocalizations.of(context).registeredOn,
                          style: _commentsStyle)),
                  Text(
                    DateFormat("dd-MM-yyyy").format(_userStats.registeredOn),
                    style: _valuesStyle,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(AppLocalizations.of(context).itemsSent,
                        style: _commentsStyle),
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    _userStats.sent.toString(),
                    style: _valuesStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(AppLocalizations.of(context).rating,
                        style: _commentsStyle),
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    _userStats.rating.toStringAsFixed(2),
                    style: _valuesStyle,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(AppLocalizations.of(context).itemsDelivered,
                        style: _commentsStyle),
                    padding: EdgeInsets.only(bottom: 4),
                  ),
                  Text(
                    _userStats.delivered.toString(),
                    style: _valuesStyle,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _reviews() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toReviews,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).reviews,
                    style: _valuesStyle,
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 8),
                  child: Text(
                    _userStats.reviewCount.toString(),
                    style: _valuesStyle,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.chevron_right,
                    color: Styles.kGreyTextColor,
                    size: 22,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _toReviews() {
    NavigationService.toReviews(widget.userId);
  }

  TextStyle get _commentsStyle {
    return TextStyle(color: Styles.kGreenColor);
  }

  TextStyle get _valuesStyle {
    return TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.1,
        color: Styles.kGreyTextColor);
  }
}
