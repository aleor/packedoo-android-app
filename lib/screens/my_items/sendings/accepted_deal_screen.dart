import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/localizable_constants.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/screens/shared/action_button_widget.dart';
import 'package:packedoo_app_material/screens/shared/carousel/carousel_widget.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/screens/shared/view_lot_icon_button_widget.dart';
import 'package:packedoo_app_material/services/contact.dart';
import 'package:packedoo_app_material/services/deals.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/styles.dart';

class AcceptedDealScreen extends StatefulWidget {
  final Pack lot;
  final bool inDelivery;

  const AcceptedDealScreen(
      {Key key, @required this.lot, this.inDelivery = false})
      : super(key: key);

  @override
  _AcceptedDealScreenState createState() => _AcceptedDealScreenState();
}

class _AcceptedDealScreenState extends State<AcceptedDealScreen> {
  final DealsService _dealService = dealsService;
  final ContactService _contactService = contactService;
  Deal _deal;
  bool _isLoading = true;

  @override
  void initState() {
    _loadDeal();

    super.initState();
  }

  void _loadDeal() async {
    final _status = widget.inDelivery ? Status.IN_PROGRESS : Status.ACCEPTED;
    final activeDeal = await _dealService.getDealFor(widget.lot.id, _status);

    setState(() {
      _deal = activeDeal;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return Scaffold(body: Center(child: CustomCircularIndicator()));

    if (_deal == null) {
      return Scaffold(
          body: Center(child: Text(AppLocalizations.of(context).dealNotFound)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lot.name),
        actions: <Widget>[
          ViewLotIconButton(
            lotId: widget.lot.id,
            userId: widget.lot.sender.uid,
          )
        ],
      ),
      body: SingleChildScrollView(child: SafeArea(child: _buildBody())),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _carousel(),
        _infoSection(),
        _actionButtons(),
      ],
    );
  }

  Widget _carousel() {
    return Container(
      child: Carousel(
        children: widget.lot.photos,
        title: widget.lot.name,
        height: 240,
      ),
    );
  }

  Widget _infoSection() {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _status,
          widget.inDelivery ? _deliverToPerson() : _pickUpFromPerson(),
          widget.inDelivery ? _deliverToAddress() : _pickUpFromAddress(),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 30),
      child: Column(
        children: <Widget>[
          Divider(
            thickness: 1,
            color: Styles.kGreyTextColor,
          ),
          _buttonsRow(),
          Divider(
            thickness: 1,
            color: Styles.kGreyTextColor,
          ),
        ],
      ),
    );
  }

  Widget _pickUpFromPerson() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Text(
        '${AppLocalizations.of(context).driverWillPickUpFrom} $_pickUpPerson',
        style: Styles.kDealActionSubTextStyle,
      ),
    );
  }

  Widget _pickUpFromAddress() {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          '${AppLocalizations.of(context).address}: $_pickUpAddress',
          style: Styles.kDealActionSubTextStyle,
        ));
  }

  Widget _deliverToPerson() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Text(
        '${AppLocalizations.of(context).driverWillDeliverTo} $_recipientPerson',
        style: Styles.kDealActionSubTextStyle,
      ),
    );
  }

  Widget _deliverToAddress() {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          '${AppLocalizations.of(context).address}: $_recipientAddress',
          style: Styles.kDealActionSubTextStyle,
        ));
  }

  Widget _buttonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ActionButton(
          icon: Icon(Icons.phone),
          text: AppLocalizations.of(context).call,
          onPressedHandler: _callDriver,
        ),
        ActionButton(
          icon: Icon(Icons.forum),
          text: AppLocalizations.of(context).chat,
          onPressedHandler: _toDealMessages,
        ),
        ActionButton(
          icon: Icon(Icons.account_circle),
          text: AppLocalizations.of(context).driver,
          onPressedHandler: _toProfile,
        )
      ],
    );
  }

  Widget get _status => Text(
        LocalizableConstants.getStatusName(
          context: context,
          statusId: widget.lot.status,
        ),
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
      );

  String get _pickUpPerson => widget.lot.sendingMyself
      ? widget.lot.sender.displayName
      : widget.lot.originContact.name;

  String get _pickUpAddress => widget.lot.origin.description;

  String get _recipientPerson => widget.lot.meetingMyself
      ? widget.lot.sender.displayName
      : widget.lot.destinationContact.name;

  String get _recipientAddress => widget.lot.destination.description;

  _callDriver() async {
    await _contactService.makeCall(
      requestPhone: true,
      dealId: _deal.id,
      context: context,
    );
  }

  _toDealMessages() {
    NavigationService.toDealMessages(_deal.id);
  }

  _toProfile() {
    NavigationService.toRegisteredUserProfile(_deal.mooverId);
  }
}
