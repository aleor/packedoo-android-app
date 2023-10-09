import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/screens/shared/action_button_widget.dart';
import 'package:packedoo_app_material/screens/shared/registered_user_infobar_widget.dart';
import 'package:packedoo_app_material/screens/shared/route_info_widget.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';

class PendingDealToSender extends StatefulWidget {
  final Deal deal;

  const PendingDealToSender({Key key, this.deal}) : super(key: key);

  @override
  _PendingDealToSenderState createState() => _PendingDealToSenderState();
}

class _PendingDealToSenderState extends State<PendingDealToSender> {
  @override
  void initState() {
    GoogleAnalytics().setScreen('pending_deal');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).pendingDealStatus),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            _infoSection(),
            _actionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _infoSection() {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title(),
          _description(),
          Container(padding: EdgeInsets.only(top: 10), child: Divider()),
          _offerTerms(),
          Container(padding: EdgeInsets.only(top: 10), child: Divider()),
          _route(),
          _senderInfo(),
        ],
      ),
    );
  }

  Widget _title() {
    return Container(
      child: Text(
        widget.deal.baseLotInfo.name,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _description() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppLocalizations.of(context).description,
              style: TextStyle(color: Styles.kGreenColor)),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: isEmpty(widget.deal.baseLotInfo.description)
                ? Text(AppLocalizations.of(context).noAdditionalDescription)
                : Text(widget.deal.baseLotInfo.description),
          )
        ],
      ),
    );
  }

  Widget _offerTerms() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(AppLocalizations.of(context).offeredPrice)),
              Text(
                '${widget.deal.price.formattedValue} ${widget.deal.price.currency}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(AppLocalizations.of(context).offeredDate)),
              Text(
                widget.deal.suggestedDateDDMMYYY,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _route() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).route,
            style: TextStyle(color: Styles.kGreenColor),
          ),
          RouteInfo(lot: widget.deal.baseLotInfo),
        ],
      ),
    );
  }

  Widget _senderInfo() {
    return Container(
      padding: EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).sender,
            style: TextStyle(color: Styles.kGreenColor),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: RegisteredUserInfoBar(user: widget.deal.sender),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 16, right: 16),
      child: Column(
        children: <Widget>[
          Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ActionButton(
                  icon: Icon(Icons.forum),
                  text: AppLocalizations.of(context).chat,
                  onPressedHandler: _toChat),
              ActionButton(
                  icon: Icon(Icons.cancel),
                  text: AppLocalizations.of(context).cancel,
                  onPressedHandler: _cancelOffer)
            ],
          ),
          Divider(thickness: 1),
        ],
      ),
    );
  }

  _toChat() {
    NavigationService.toDealMessages(widget.deal.id);
  }

  _cancelOffer() {
    NavigationService.toCancelDeal(widget.deal);
  }
}
