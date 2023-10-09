import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/localizable_constants.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/screens/shared/action_button_widget.dart';
import 'package:packedoo_app_material/screens/shared/carousel/carousel_widget.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/screens/shared/view_lot_icon_button_widget.dart';
import 'package:packedoo_app_material/services/api.dart';
import 'package:packedoo_app_material/services/contact.dart';
import 'package:packedoo_app_material/services/deals.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/lots.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';

class ActiveDeliveryScreen extends StatefulWidget {
  final String dealId;

  const ActiveDeliveryScreen({Key key, @required this.dealId})
      : super(key: key);

  @override
  _ActiveDeliveryScreenState createState() => _ActiveDeliveryScreenState();
}

class _ActiveDeliveryScreenState extends State<ActiveDeliveryScreen> {
  final DealsService _dealService = dealsService;
  final ContactService _contactService = contactService;
  final UIService _uiService = uiService;
  final ApiService _apiService = apiService;
  final LotsService _lotsService = lotsService;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PersistentBottomSheetController _bottomSheetController;

  Deal _deal;
  Pack _lot;
  bool _isLoading = true;

  @override
  void initState() {
    _loadData();
    GoogleAnalytics().setScreen('in_delivery_deal');
    super.initState();
  }

  void _loadData() async {
    Deal activeDeal = await _dealService.getDeal(widget.dealId);
    Pack lotData = await _lotsService.getPack(activeDeal.baseLotInfo.id);

    setState(() {
      _deal = activeDeal;
      _lot = lotData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return Scaffold(body: Center(child: CustomCircularIndicator()));

    if (_deal == null || _lot == null) {
      return Scaffold(
          body: Center(child: Text(AppLocalizations.of(context).dealNotFound)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_deal.baseLotInfo.name),
        actions: <Widget>[
          ViewLotIconButton(
            lotId: _deal.baseLotInfo.id,
            userId: _deal.sender.uid,
          )
        ],
      ),
      body: SingleChildScrollView(child: SafeArea(child: _buildBody())),
      key: _scaffoldKey,
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _closeBottomSheet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _carousel(),
          _infoSection(),
          _actionButtons(),
          _updateDeliveryStateButton(),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _carousel() {
    return Container(
      child: Carousel(
        children: _deal.baseLotInfo.photos,
        title: _deal.baseLotInfo.name,
        height: 250,
      ),
    );
  }

  Widget _infoSection() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _status,
          _inDelivery ? _deliverToPerson() : _pickUpFromPerson(),
          _inDelivery ? _deliverToAddress() : _pickUpFromAddress(),
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
        '${AppLocalizations.of(context).pickUpParcelFrom} $_pickUpPerson',
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
        '${AppLocalizations.of(context).deliverParcelTo} $_recipientPerson',
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
          text: AppLocalizations.of(context).sender,
          onPressedHandler: _toProfile,
        )
      ],
    );
  }

  Widget _updateDeliveryStateButton() {
    if (!_inDelivery) {
      return Container(
        padding: EdgeInsets.only(top: 25, left: 16, right: 16),
        child: RaisedButton(
          color: Styles.kGreenColor,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Text(
              AppLocalizations.of(context).parcelPickedUp,
              style: Styles.kButtonUpperTextStyle,
            ),
          ),
          onPressed: _onItemPickedUp,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(top: 25, left: 16, right: 16),
      child: RaisedButton(
        color: Styles.kGreenColor,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: Text(
            AppLocalizations.of(context).didDeliver,
            style: Styles.kButtonUpperTextStyle,
          ),
        ),
        onPressed: _onItemDelivered,
      ),
    );
  }

  Widget get _status => Text(
        LocalizableConstants.getStatusName(
          context: context,
          statusId: _deal.status,
        ),
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
      );

  String get _pickUpPerson =>
      _lot.sendingMyself ? _lot.sender.displayName : _lot.originContact.name;

  String get _pickUpAddress => _deal.baseLotInfo.origin.description;

  String get _recipientPerson => _lot.meetingMyself
      ? _lot.sender.displayName
      : _lot.destinationContact.name;

  bool get _inDelivery =>
      PackConstants.statusIdMap[Status.IN_PROGRESS] == _deal.status;

  String get _recipientAddress => _deal.baseLotInfo.destination.description;

  _callDriver() async {
    await _contactService.makeCall(
      requestPhone: true,
      dealId: _deal.id,
      context: context,
    );
  }

  _onItemPickedUp() async {
    _uiService.showActivityIndicator(context);

    try {
      await _apiService.collectDeal(_deal.id);
    } catch (e) {
      _uiService.hideActivityIndicator(context, true);
      _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).error,
        AppLocalizations.of(context).cantMakeRequest,
      );
      return;
    }

    _uiService.hideActivityIndicator(context, true);

    NavigationService.replaceWithActiveDelivery(_deal.id);
  }

  _toDealMessages() {
    NavigationService.replaceWithDealMessages(_deal.id);
  }

  _toProfile() {
    NavigationService.toRegisteredUserProfile(_deal.senderId);
  }

  _onItemDelivered() {
    GoogleAnalytics().dealRequestCode(source: 'dealScreen');

    _bottomSheetController =
        _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      return Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 120,
        child: TextField(
          autocorrect: false,
          maxLines: 1,
          maxLength: 6,
          maxLengthEnforced: true,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          onSubmitted: (input) => _checkCode(input),
          onChanged: (input) => _checkCode(input),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).pleaseProvideDeliveryCode,
              helperText: AppLocalizations.of(context).codeYouCanGetFromSender),
        ),
      );
    });
  }

  _checkCode(String input) async {
    GoogleAnalytics().dealEnterCode(source: 'dealScreen');

    if (isEmpty(input) || input.length < 6) return;

    final int _code = int.tryParse(input);

    if (_code == null) {
      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).error,
        AppLocalizations.of(context).invalidCodeFormat,
      );
      return;
    }

    int result = -1;

    try {
      _uiService.showActivityIndicator(context);
      result = await _apiService.deliverDeal(_deal.id, _code);
      _uiService.hideActivityIndicator(context, true);

      if (result == -1) {
        _uiService.showInfoDialog(
          context,
          AppLocalizations.of(context).error,
          AppLocalizations.of(context).cantMakeRequest,
        );
        return;
      }

      if (result == 403) {
        await _uiService.showInfoDialog(
            context,
            AppLocalizations.of(context).error,
            AppLocalizations.of(context).invalidCode);

        return;
      }

      if (result == 200) {
        _toReviewScreen();
        return;
      }
    } catch (e) {
      _uiService.hideActivityIndicator(context, true);
      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).error,
        AppLocalizations.of(context).unableToVerifyCodeTryAgainLater,
      );
    }
  }

  _closeBottomSheet() {
    if (_bottomSheetController != null) {
      _bottomSheetController.close();
      _bottomSheetController = null;
    }
  }

  _toReviewScreen() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context).deliveryConfirmed),
    ));

    NavigationService.replaceWithDealReview(_deal.baseLotInfo.id,
        isSender: false);
  }
}
