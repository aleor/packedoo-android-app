import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/base_user_info.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/models/review.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/screens/shared/registered_user_infobar_widget.dart';
import 'package:packedoo_app_material/screens/shared/view_lot_icon_button_widget.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/deals.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/reviews.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';

class DealReviewScreen extends StatefulWidget {
  final String packId;
  final bool isSender;

  const DealReviewScreen({Key key, @required this.packId, this.isSender = true})
      : super(key: key);

  @override
  _DealReviewScreenState createState() => _DealReviewScreenState();
}

class _DealReviewScreenState extends State<DealReviewScreen> {
  final DealsService _dealService = dealsService;
  final ReviewsService _reviewsService = reviewsService;
  final UIService _uiService = uiService;
  final AuthService _authService = authService;

  TextEditingController _commentsController = TextEditingController();
  Deal deal;
  Review review;

  double _ratingPoints = 0;
  bool _isLoading = false;

  final FocusNode _focusNode = FocusNode();
  StateModel _state;

  @override
  void initState() {
    _loadDeal();
    GoogleAnalytics().setScreen('deal_review');
    super.initState();
  }

  void _loadDeal() async {
    _isLoading = true;
    review = await _reviewsService.getReviewFor(widget.packId);

    final completedDeal = await _dealService.getDealFor(
      widget.packId,
      Status.CONFIRMED,
      isSender: widget.isSender,
    );

    _isLoading = false;

    setState(() {
      deal = completedDeal;
    });
  }

  BaseUserInfo get _counterparty =>
      deal.senderId == _authService.currentUserId ? deal.moover : deal.sender;

  @override
  Widget build(BuildContext context) {
    _state = StateWidget.of(context).state;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).review),
        actions: <Widget>[
          ViewLotIconButton(
            lotId: widget.packId,
            userId: _authService.currentUserId,
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return SafeArea(
        child: Center(
          child: CustomCircularIndicator(),
        ),
      );
    }

    if (deal == null) {
      return _dealNotFound();
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _name(),
                _person(),
                review.createdOn != null ? _ratingReadOnly() : _rating(),
                review.createdOn != null ? _comment() : _commentArea(),
                review.createdOn == null ? _submitButton() : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _name() {
    return Container(
      child: Text(
        deal.baseLotInfo.name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _person() {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: RegisteredUserInfoBar(
        user: _counterparty,
        header: Container(
            alignment: Alignment.centerLeft,
            child: Text(AppLocalizations.of(context).deliveredBy)),
      ),
    );
  }

  Widget _ratingReadOnly() {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(AppLocalizations.of(context).yourMark),
          ),
          Container(
            child: FlutterRatingBarIndicator(
                itemCount: 5,
                rating: review.rating ?? 0,
                itemSize: 35.0,
                fillColor: Styles.kGreenColor,
                emptyColor: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _comment() {
    if (review.text == null || review.text.trim().length == 0) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 25),
          child: Text(AppLocalizations.of(context).comment),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  review.text,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Styles.kGreyTextColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _submitButton() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      alignment: Alignment.center,
      child: RaisedButton(
        color: Styles.kGreenColor,
        child: Text(
          AppLocalizations.of(context).leaveReview,
          style: Styles.kButtonUpperTextStyle,
        ),
        onPressed: _submitReview,
      ),
    );
  }

  void _submitReview() async {
    if (_ratingPoints == 0) {
      _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).noRatingGiven,
        AppLocalizations.of(context).pleaseAddRatingMark,
      );

      return;
    }

    _uiService.showActivityIndicator(context);

    final review = Review(
        dealId: deal.id,
        lotId: widget.packId,
        rating: _ratingPoints,
        revieweeId: _counterparty.uid,
        text: _commentsController.text);

    await _reviewsService.addReview(review);

    _uiService.hideActivityIndicator(context, true);

    final _snackBar =
        SnackBar(content: Text(AppLocalizations.of(context).thankYouForReview));

    _state.mainScaffoldKey.currentState.showSnackBar(_snackBar);

    Navigator.of(context).pop();
  }

  Widget _rating() {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppLocalizations.of(context).yourMark),
          FlutterRatingBar(
            borderColor: Styles.kGreenColor,
            fillColor: Styles.kGreenColor,
            itemSize: 45,
            tapOnlyMode: true,
            onRatingUpdate: (double rating) {
              setState(() {
                _ratingPoints = rating;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _commentArea() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: TextField(
        decoration: InputDecoration(
            hintText: AppLocalizations.of(context).yourReviewComments),
        controller: _commentsController,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        maxLength: PackConstants.kMaxDeliveryMessageLength,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _dealNotFound() {
    return SafeArea(
      child: Center(
        child: Container(
          child: Text(AppLocalizations.of(context).dealNotFound),
        ),
      ),
    );
  }
}
