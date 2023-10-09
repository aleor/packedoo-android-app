import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/review.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/images.dart';
import 'package:packedoo_app_material/services/reviews.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';

class ReviewsScreen extends StatefulWidget {
  final String userId;

  const ReviewsScreen({Key key, this.userId}) : super(key: key);

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  ReviewsService _reviewsService = reviewsService;
  ImageService _imageService = imageService;
  List<Review> _reviews;

  @override
  void initState() {
    GoogleAnalytics().setScreen('user_reviews');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).reviews),
      ),
      body: FutureBuilder(
          future: _reviewsService.getReviewsForUser(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.active) {
              return Center(child: CustomCircularIndicator());
            }

            _reviews = snapshot.data;

            return _buildPage();
          }),
    );
  }

  Widget _buildPage() {
    if (_reviews == null || _reviews.length == 0) {
      return SafeArea(
        child: Center(
          child: Text(AppLocalizations.of(context).noReviewsYet),
        ),
      );
    }

    return SafeArea(
      child: ListView.builder(
        itemCount: _reviews.length,
        itemBuilder: (BuildContext context, int index) {
          return _getReviewRow(index);
        },
      ),
    );
  }

  Widget _getReviewRow(int index) {
    var _review = _reviews[index];

    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 16, right: 16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: _imageService.getNetworkImageOrPlaceholder(
                        imageUrl: _review.reviewer?.photoUrl ?? '',
                        placeholder: 'assets/images/default_user.png',
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 2),
                                  child: Text(
                                    _review.lot?.name ?? '',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.1,
                                        color: Color(0xff4a4a4a)),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      DateFormat('dd.MM.yyyy')
                                          .format(_review.createdOn),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          letterSpacing: -0.08,
                                          color: Color(0xff8f8e94)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            _rating(_review),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                _text(_review),
              ],
            ),
            SizedBox(height: 10),
            if (index != _reviews.length - 1) Divider(),
          ],
        ),
      ),
    );
  }

  Widget _rating(Review _review) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 10),
      child: FlutterRatingBarIndicator(
        rating: _review.rating ?? 0,
        itemCount: 5,
        itemSize: 20.0,
        fillColor: Styles.kGreenColor,
        emptyColor: Colors.grey,
      ),
    );
  }

  Widget _text(Review _review) {
    return Container(
      padding: EdgeInsets.only(left: 2),
      child: Text(
        isEmpty(_review.text)
            ? AppLocalizations.of(context).noComments
            : _review.text,
        style: TextStyle(
          fontSize: 15,
          letterSpacing: -0.08,
          color: Color(0xff8f8e94),
        ),
      ),
    );
  }
}
