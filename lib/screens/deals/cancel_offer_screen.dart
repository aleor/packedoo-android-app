import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/screens/shared/registered_user_infobar_widget.dart';
import 'package:packedoo_app_material/services/api.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';

class CancelOfferScreen extends StatefulWidget {
  final Deal deal;

  const CancelOfferScreen({Key key, this.deal}) : super(key: key);

  @override
  _CancelOfferScreenState createState() => _CancelOfferScreenState();
}

class _CancelOfferScreenState extends State<CancelOfferScreen> {
  TextEditingController _cancelReasonController = TextEditingController();
  UIService _uiService = uiService;
  ApiService _apiService = apiService;
  AuthService _authService = authService;

  FocusNode _focusNode = FocusNode();
  StateModel _state;

  @override
  void initState() {
    GoogleAnalytics().setScreen('cancel_deal');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _state = StateWidget.of(context).state;

    return Scaffold(
      appBar: AppBar(
        title: Text(_header),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
        child: SingleChildScrollView(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(_focusNode);
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _title(),
              _description(),
              _senderInfo(),
              _cancellationReasonInput(),
              _cancelButton(),
              SizedBox(height: 40)
            ],
          ),
        ),
      ),
    ));
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

  Widget _cancellationReasonInput() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: TextField(
        controller: _cancelReasonController,
        maxLines: 2,
        maxLength: 200,
        maxLengthEnforced: true,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context).cancellationReasonUpper),
      ),
    );
  }

  Widget _cancelButton() {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 30),
      width: double.infinity,
      child: RaisedButton(
        color: Styles.kGreenColor,
        child: Text(
          _buttonText,
          style: Styles.kButtonUpperTextStyle,
        ),
        onPressed: _cancelOffer,
      ),
    );
  }

  _cancelOffer() async {
    if (isEmpty(_cancelReasonController.text?.trim())) {
      await _uiService.showInfoDialog(
          context,
          AppLocalizations.of(context).cancellationReasonMissing,
          AppLocalizations.of(context).pleaseProvideCancellationReason);

      return;
    }

    _uiService.showActivityIndicator(context);
    await _apiService.cancelDeal(widget.deal.id, _cancelReasonController.text);
    _uiService.hideActivityIndicator(context, true);

    final _snackBar = SnackBar(
        content: Text(AppLocalizations.of(context).dealCancelledSuccessfully));

    _state.mainScaffoldKey.currentState.showSnackBar(_snackBar);

    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  bool get _isMoover => widget.deal.mooverId == _authService.currentUserId;

  String get _header => _isMoover
      ? AppLocalizations.of(context).dealCancellation
      : AppLocalizations.of(context).offerCancellation;

  String get _buttonText => _isMoover
      ? AppLocalizations.of(context).toCancelDeal
      : AppLocalizations.of(context).toCancelOffer;
}
