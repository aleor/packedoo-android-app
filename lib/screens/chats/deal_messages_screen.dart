import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/localizable_constants.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/models/message.dart';
import 'package:packedoo_app_material/screens/chats/message_row.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/screens/shared/side_menu_widget.dart';
import 'package:packedoo_app_material/services/api.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/contact.dart';
import 'package:packedoo_app_material/services/deals.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/messages.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';

class DealMessagesScreen extends StatefulWidget {
  final Deal deal;
  final String dealId;
  final bool fromPackedoo;
  final bool hasDrawer;

  const DealMessagesScreen(
      {Key key,
      this.dealId,
      this.deal,
      this.fromPackedoo = false,
      this.hasDrawer = false})
      : super(key: key);

  @override
  _DealMessagesScreenState createState() => _DealMessagesScreenState();
}

// TODO: REFACTOR ONCE DONE
class _DealMessagesScreenState extends State<DealMessagesScreen> {
  final MessagesService _messagesService = messagesService;
  final AuthService _authService = authService;
  final DealsService _dealsService = dealsService;
  final UIService _uiService = uiService;
  final ApiService _apiService = apiService;
  final ContactService _contactService = contactService;

  TextEditingController _messageTextController = TextEditingController();
  PersistentBottomSheetController _bottomSheetController;
  Deal _deal;
  StreamSubscription _dealSubscription;

  List<Message> _messages = [];
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;

  @override
  void initState() {
    _markAsSeen();
    _loadDeal();
    _watchDeal();

    GoogleAnalytics().setScreen('deal_messages');
    super.initState();
  }

  @override
  void dispose() {
    if (_dealSubscription != null) {
      _dealSubscription.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return Scaffold(body: Center(child: CustomCircularIndicator()));

    if (_deal == null && !widget.fromPackedoo) {
      return Scaffold(
          body: Center(child: Text(AppLocalizations.of(context).dealNotFound)));
    }

    return Scaffold(
      appBar: AppBar(
        title: _getTitle(),
        actions: _getActions(),
      ),
      body: SafeArea(child: _buildBody()),
      drawer: widget.hasDrawer ? SideMenu(activeItem: MenuItem.Messages) : null,
      key: _scaffoldKey,
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _closeBottomSheet();
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: widget.fromPackedoo
                  ? _messagesService.getUserMessages()
                  : _messagesService.getMessagesForDeal(_deal.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                if (snapshot.data.documents.isEmpty) return Container();

                _markAsSeen();

                _messages = List<Message>.from(snapshot.data.documents
                        .map((document) => Message.fromMap(document.data)))
                    .reversed
                    .where((m) =>
                        m.recipientId == _authService.currentUserId ||
                        m.senderId == _authService.currentUserId)
                    .toList();

                return _buildMessagesList();
              }),
          _actionButtons(),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: _inputField(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return Expanded(
      child: ListView.builder(
          reverse: true,
          itemCount: _messages.length,
          itemBuilder: (BuildContext context, int index) {
            return MessageRow(
              deal: _deal,
              message: _messages[index],
            );
          }),
    );
  }

  Widget _inputField() {
    return Container(
      color: Color(0xff008C94),
      padding: EdgeInsets.all(6),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: TextField(
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 3,
                    enabled: _isActiveDeal,
                    controller: _messageTextController,
                    style:
                        TextStyle(color: Color.fromRGBO(255, 255, 255, 0.95)),
                    decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: _isActiveDeal
                            ? AppLocalizations.of(context).sendMessage
                            : AppLocalizations.of(context).chatIsDisabled,
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.8))),
                  ),
                ),
              ),
              if (_isActiveDeal)
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: _isActiveDeal ? _addMessage : null,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    if (_canAccept) {
      return Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _selectPersonButton(),
            SizedBox(width: 20),
            _declinePersonButton(),
          ],
        ),
      );
    }

    if (_canBePickedUp) {
      return Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _parcelPickedUpButton(),
          ],
        ),
      );
    }

    if (_canBeDelivered) {
      return Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _parcelDeliveredButton(),
          ],
        ),
      );
    }

    if (!_isActiveDeal && _awaitingReview) {
      return Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _leaveReviewButton(),
          ],
        ),
      );
    }

    return Container();
  }

  bool get _canBePickedUp =>
      (_deal?.status == PackConstants.statusIdMap[Status.ACCEPTED]) &&
      _isMoover;

  bool get _canBeDelivered =>
      (_deal?.status == PackConstants.statusIdMap[Status.IN_PROGRESS]) &&
      _isMoover;

  bool get _canAccept =>
      (_deal?.status == PackConstants.statusIdMap[Status.PENDING]) &&
      (_deal.senderId == _authService.currentUserId);

  bool get _awaitingReview =>
      (!_deal.hasMooverReview && _isMoover) ||
      (!_deal.hasSenderReview && !_isMoover);

  Widget _selectPersonButton() {
    return Expanded(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        color: Styles.kGreenColor,
        textColor: Colors.white,
        onPressed: _acceptOffer,
        child: Row(
          children: <Widget>[
            Icon(Icons.check, color: Colors.white),
            Container(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                AppLocalizations.of(context).select.toUpperCase(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _declinePersonButton() {
    return Expanded(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        color: Colors.white,
        textColor: Styles.kGreenColor,
        onPressed: _declineOffer,
        child: Row(
          children: <Widget>[
            Icon(Icons.cancel, color: Styles.kGreenColor),
            Container(
                padding: EdgeInsets.only(left: 5),
                child:
                    Text(AppLocalizations.of(context).decline.toUpperCase())),
          ],
        ),
      ),
    );
  }

  Widget _parcelPickedUpButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      color: Styles.kGreenColor,
      textColor: Colors.white,
      onPressed: _onItemPickedUp,
      child: Row(
        children: <Widget>[
          Icon(Icons.check, color: Colors.white),
          Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Text(
                  AppLocalizations.of(context).parcelPickedUp.toUpperCase())),
        ],
      ),
    );
  }

  Widget _parcelDeliveredButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      color: Styles.kGreenColor,
      textColor: Colors.white,
      onPressed: _onItemDelivered,
      child: Row(
        children: <Widget>[
          Icon(Icons.check, color: Colors.white),
          Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              child:
                  Text(AppLocalizations.of(context).didDeliver.toUpperCase())),
        ],
      ),
    );
  }

  Widget _leaveReviewButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      color: Styles.kGreenColor,
      textColor: Colors.white,
      onPressed: _leaveReview,
      child: Row(
        children: <Widget>[
          Icon(Icons.check, color: Colors.white),
          Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              child:
                  Text(AppLocalizations.of(context).leaveReview.toUpperCase())),
        ],
      ),
    );
  }

  _onItemDelivered() {
    GoogleAnalytics().dealRequestCode(source: 'chat');

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
    GoogleAnalytics().dealEnterCode(source: 'chat');

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
        await _uiService.showInfoDialog(
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

  _addMessage() {
    if (isEmpty(_messageTextController?.text?.trim())) return;

    widget.fromPackedoo ? _sendToPackedoo() : _sendDealMessage();

    _messageTextController.text = '';
  }

  _sendDealMessage() {
    var _recipientId = _deal.senderId == _authService.currentUserId
        ? _deal.mooverId
        : _deal.senderId;

    final _message =
        Message(_deal.id, _recipientId, _messageTextController.text.trim());

    _messagesService.sendMessage(_message);
  }

  _sendToPackedoo() {
    _messagesService.sendToPackedoo(_messageTextController.text.trim());
  }

  _leaveReview() {
    NavigationService.toDealReview(_deal.lotId, isSender: !_isMoover);
  }

  Widget _getTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 2, bottom: 2),
          child: Text(_title),
        ),
        if (!widget.fromPackedoo)
          Container(
            padding: EdgeInsets.only(bottom: 1),
            child: Text(
              _statusName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.1,
                color: Styles.kGreyTextColor,
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _getActions() {
    List<Widget> _actions = [];

    if (_canCall) {
      _actions.add(
        Center(
          child: IconButton(
            icon: Icon(
              Icons.phone,
              color: Styles.kGreyTextColor,
            ),
            onPressed: _call,
          ),
        ),
      );
    }

    if (_hasMenu) {
      _actions.add(
        Center(
          child: IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Styles.kGreyTextColor,
            ),
            onPressed: _showBottomSheet,
          ),
        ),
      );
    }

    return _actions;
  }

  bool get _hasMenu => !widget.fromPackedoo;

  bool get _canCall =>
      !widget.fromPackedoo && _statusesAllowedForCalling.contains(_deal.status);

  List<int> _statusesAllowedForCalling = [
    PackConstants.statusIdMap[Status.ACCEPTED],
    PackConstants.statusIdMap[Status.IN_PROGRESS],
  ];

  String get _title => widget.fromPackedoo
      ? AppLocalizations.of(context).chatWithPackedoo
      : _deal.baseLotInfo.name;

  String get _statusName =>
      (_deal.status == PackConstants.statusIdMap[Status.PENDING] &&
              _deal.mooverId == _authService.currentUserId)
          ? AppLocalizations.of(context).pendingDealStatus
          : LocalizableConstants.getStatusName(
              context: context, statusId: _deal.status);

  Future _loadDeal() async {
    if (widget.fromPackedoo) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var _loadedDeal = widget.deal ?? await _dealsService.getDeal(widget.dealId);

    setState(() {
      _deal = _loadedDeal;
      _isLoading = false;
    });
  }

  _watchDeal() {
    if (widget.fromPackedoo) return;

    _dealSubscription =
        _dealsService.watchDeal(widget.dealId).listen((deal) => setState(() {
              _deal = deal;
            }));
  }

  Future _markAsSeen() async {
    widget.fromPackedoo
        ? _messagesService.markAsReadForInternalChat()
        : _messagesService.markAsReadForDeal(widget.dealId);
  }

  bool get _isActiveDeal {
    if (widget.fromPackedoo) return true;

    return _deal.status <= PackConstants.statusIdMap[Status.DELIVERED];
  }

  Future _declineOffer() async {
    _uiService.showActivityIndicator(context);
    final result = await _apiService.declineDeal(_deal.id);
    _uiService.hideActivityIndicator(context, true);

    final message =
        (result) ? '' : AppLocalizations.of(context).cantMakeRequest;
    final title = (result)
        ? AppLocalizations.of(context).offerDeclined
        : AppLocalizations.of(context).error;

    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text('$title $message')));

    _loadDeal();
  }

  Future _acceptOffer() async {
    _uiService.showActivityIndicator(context);
    final result = await _apiService.acceptDeal(_deal.id);
    _uiService.hideActivityIndicator(context, true);

    if (!result) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).cantMakeRequest),
      ));
      return;
    }

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context).offerAccepted),
    ));

    _loadDeal();
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

    _loadDeal();
  }

  bool get _isMoover => _deal.mooverId == _authService.currentUserId;

  _call() async {
    await _contactService.makeCall(
      requestPhone: true,
      dealId: _deal.id,
      context: context,
    );
  }

  List<Widget> _getAvailableMenuActions() {
    List<Widget> _actions = [
      ListTile(
        leading: Icon(Icons.info),
        title: Text(AppLocalizations.of(context).itemDescription),
        onTap: () {
          Navigator.of(context).pop();
          _showLot();
        },
      ),
      ListTile(
        leading: Icon(Icons.account_circle),
        title: Text(_isMoover
            ? AppLocalizations.of(context).senderProfile
            : AppLocalizations.of(context).driverProfile),
        onTap: () {
          Navigator.of(context).pop();
          _showProfile();
        },
      ),
    ];

    if (_deal.status < PackConstants.statusIdMap[Status.IN_PROGRESS]) {
      _actions.add(_cancelOfferTile());
    }

    return _actions;
  }

  Widget _cancelOfferTile() {
    return ListTile(
      leading: Icon(Icons.cancel),
      title: Text(_isMoover
          ? AppLocalizations.of(context).offerCancellation
          : AppLocalizations.of(context).dealCancellation),
      onTap: () {
        Navigator.of(context).pop();
        _cancelOfferOrDeal();
      },
    );
  }

  _showBottomSheet() {
    var _actions = _getAvailableMenuActions();

    if (_actions.length == 0) return;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: _actions.length * 58.0,
            child: Column(
              children: _actions,
            ));
      },
    );
  }

  _showLot() {
    NavigationService.toLotViewScreen(
        lotId: _deal.baseLotInfo.id,
        isMy: _authService.currentUserId == _deal.senderId,
        actionsEnabled: false);
  }

  _showProfile() {
    final _userId = _isMoover ? _deal.senderId : _deal.mooverId;

    NavigationService.toRegisteredUserProfile(_userId);
  }

  _cancelOfferOrDeal() {
    NavigationService.toCancelDeal(_deal);
  }

  _toReviewScreen() async {
    _closeBottomSheet();

    await _loadDeal();

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context).deliveryConfirmed),
    ));
  }
}
