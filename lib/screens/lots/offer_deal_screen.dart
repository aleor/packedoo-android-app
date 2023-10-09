import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/models/price.dart';
import 'package:packedoo_app_material/screens/shared/carousel/carousel_widget.dart';
import 'package:packedoo_app_material/services/deals.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/services/users.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';

class OfferDealScreen extends StatefulWidget {
  final Pack lot;

  const OfferDealScreen({Key key, this.lot}) : super(key: key);

  @override
  _OfferDealScreenState createState() => _OfferDealScreenState();
}

class _OfferDealScreenState extends State<OfferDealScreen> {
  TextEditingController _priceController;
  TextEditingController _dateController;
  TextEditingController _commentController;

  DateTime _deliveryDate = DateTime.now().add(Duration(days: 1));
  UIService _uiService = uiService;
  UsersService _usersService = usersService;
  DealsService _dealsService = dealsService;
  StateWidgetState _appState;

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    GoogleAnalytics().setScreen('offer_deal');

    _priceController =
        TextEditingController(text: widget.lot.price.formattedValue);
    _dateController =
        TextEditingController(text: _formatInputDate(_deliveryDate));
    _commentController = TextEditingController();

    SchedulerBinding.instance.addPostFrameCallback((_) => _commentController
        .text = AppLocalizations.of(context).kDefaultDeliveryMessage);
  }

  @override
  Widget build(BuildContext context) {
    _appState = StateWidget.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).offer)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _carousel(),
              _name(),
              _dealTerms(),
              _makeProposalButton(),
              SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }

  Widget _carousel() {
    return Container(
      child: Carousel(
        children: widget.lot.photos,
        title: widget.lot.name,
        height: 160,
      ),
    );
  }

  Widget _name() {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 16, right: 16),
      child: Text(
        widget.lot.name,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _dealTerms() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 5),
      child: Column(
        children: <Widget>[
          _price(),
          _date(),
          _comment(),
        ],
      ),
    );
  }

  Widget _price() {
    return Container(
      child: TextField(
        style: TextStyle(fontSize: 18),
        controller: _priceController,
        autocorrect: false,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          suffixText: widget.lot.price.currency,
          labelText: AppLocalizations.of(context).yourPrice,
          // contentPadding: EdgeInsets.only(bottom: 5, top: 5),
        ),
      ),
    );
  }

  Widget _date() {
    return Container(
      child: TextField(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _showDatePicker();
        },
        controller: _dateController,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).youWillDeliverUntil,
        ),
      ),
    );
  }

  Widget _comment() {
    return Container(
      child: TextField(
        controller: _commentController,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 3,
        autocorrect: true,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).comment,
        ),
      ),
    );
  }

  Widget _makeProposalButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 35, left: 16, right: 16),
      child: RaisedButton(
        color: Styles.kGreenColor,
        child: Text(
          AppLocalizations.of(context).readyToDeliver.toUpperCase(),
          style: Styles.kButtonUpperTextStyle,
        ),
        onPressed: _sendOffer,
      ),
    );
  }

  _showDatePicker() async {
    var _selectedDate = await showDatePicker(
      context: context,
      initialDate: _deliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return child;
      },
    );

    if (_selectedDate == null || !_isInFuture(_selectedDate)) {
      return;
    }

    setState(() {
      _deliveryDate = _selectedDate;
      _dateController.text = _formatInputDate(_deliveryDate);
    });
  }

  bool _isInFuture(DateTime newDateTime) {
    final currentDateTime = DateTime.now();

    return newDateTime.year >= currentDateTime.year &&
        newDateTime.month >= currentDateTime.month &&
        newDateTime.day >= currentDateTime.day;
  }

  String _formatInputDate(DateTime date) => DateFormat.yMMMMd().format(date);

  _sendOffer() async {
    if (isEmpty(_appState.state.user.phoneNumber) &&
        !await _usersService.hasPhoneNumber()) {
      _toAddPhoneScreen();
      return;
    }

    if (!_appState.state.user.phoneVerified &&
        !await _usersService.isPhoneVerified()) {
      _toConfirmPhoneScreen();
      return;
    }

    await _createOffer();
  }

  _createOffer() async {
    _uiService.showActivityIndicator(context);

    String _dealId;
    final _comment = isEmpty(_commentController.text)
        ? AppLocalizations.of(context).kDefaultDeliveryMessage
        : _commentController.text;

    final _priceValue =
        double.tryParse(_priceController.text) ?? widget.lot.price.value;

    final deal = Deal(
        widget.lot.id,
        _comment,
        Price(value: _priceValue, currency: widget.lot.price.currency),
        _deliveryDate);

    try {
      _dealId = await _dealsService.offerDeal(deal);
      _uiService.hideActivityIndicator(context, true);
    } on PlatformException {
      _uiService.hideActivityIndicator(context, true);
      _showErrorMessage();
      return;
    }

    if (_dealId != null) {
      final _snackBar = SnackBar(
          content:
              Text(AppLocalizations.of(context).offerCreatedInPendingState));

      _appState.state.mainScaffoldKey.currentState.showSnackBar(_snackBar);

      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  void _showErrorMessage() {
    final title = AppLocalizations.of(context).error;
    final message = AppLocalizations.of(context).unableToSendOffer;

    _uiService.showInfoDialog(context, title, message);
  }

  _toAddPhoneScreen() {
    NavigationService.toAddPhone();
  }

  _toConfirmPhoneScreen() {
    NavigationService.toConfirmPhone();
  }
}
