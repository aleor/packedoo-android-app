import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/photo.dart';
import 'package:packedoo_app_material/models/price.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/screens/shared/action_progress_bar_widget.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/screens/shared/dotted_line_painter.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/cost.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/lots.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/services/upload.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';

class NewItemForthScreen extends StatefulWidget {
  final Price recommendedPrice;

  const NewItemForthScreen({Key key, this.recommendedPrice}) : super(key: key);

  @override
  _NewItemForthScreenState createState() => _NewItemForthScreenState();
}

class _NewItemForthScreenState extends State<NewItemForthScreen> {
  UIService _uiService = uiService;
  UploadService _uploadService = uploadService;
  LotsService _lotsService = lotsService;
  AuthService _authService = authService;
  CostService _costService = costService;

  TextEditingController _priceController;

  Price _price = Price();
  Price _commission = Price();
  Price _recommendedPrice;

  double get _totalPriceValue => _price.value + _commission.value;

  StateModel state;

  @override
  void initState() {
    _recommendedPrice = widget.recommendedPrice;

    if (_recommendedPrice != null) {
      _price = _recommendedPrice;
      _priceController =
          TextEditingController(text: _price.formattedValue.toString());
    }

    GoogleAnalytics().setScreen('new_item_step_4');

    SchedulerBinding.instance
        .addPostFrameCallback((_) => _ensureRecommendedPrice);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    state = StateWidget.of(context).state;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).sendPack),
      ),
      bottomNavigationBar: _progressBar(),
      body: _buildBody(),
    );
  }

  Widget _progressBar() {
    return ActionProgressBar(
      value: 1,
      handler: _createLot,
      buttonTitle: AppLocalizations.of(context).done.toUpperCase(),
    );
  }

  Widget _buildBody() {
    if (_recommendedPrice == null) {
      return SafeArea(
        child: Center(
          child: CustomCircularIndicator(),
        ),
      );
    }

    return SingleChildScrollView(
      child: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _recommendedPriceText(),
                _priceField(),
                _commissionText(),
                _dottedLine(),
                _totalText(),
                _dottedLine(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dottedLine() {
    return Container(
      height: 1,
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: DottedLinePainter(),
      ),
    );
  }

  Widget _recommendedPriceText() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Text(
        '${AppLocalizations.of(context).recommendedPrice}: ' +
            '${_recommendedPrice.formattedValue} ${_recommendedPrice.currency}',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _priceField() {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              AppLocalizations.of(context).youCanChangePrice,
              style: TextStyle(color: Styles.kGreyTextColor),
            ),
          ),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            maxLength: 5,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context).yourPrice,
                suffixText: _recommendedPrice.currency,
                counterText: ''),
            onChanged: (String value) {
              setState(() {
                _price = Price(
                    value: double.tryParse(value) ?? 0,
                    currency: _recommendedPrice.currency);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _commissionText() {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              AppLocalizations.of(context).packedooCommission,
              style: TextStyle(color: Styles.kGreyTextColor),
            ),
          ),
          TextField(
            readOnly: true,
            enabled: false,
            controller: TextEditingController(text: _commission.formattedValue),
            decoration: InputDecoration(
              suffixText: _recommendedPrice.currency,
              border: InputBorder.none,
            ),
          )
        ],
      ),
    );
  }

  Widget _totalText() {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              AppLocalizations.of(context).total,
              style: TextStyle(color: Styles.kGreyTextColor),
            ),
          ),
          TextField(
            readOnly: true,
            enabled: false,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            controller: TextEditingController(
                text: _totalPriceValue.round().toString()),
            decoration: InputDecoration(
              suffixText: _recommendedPrice.currency,
              border: InputBorder.none,
            ),
          )
        ],
      ),
    );
  }

  _ensureRecommendedPrice() async {
    if (_recommendedPrice != null) return;

    try {
      final _value = await _costService.calculate(
        originCoordinates: state.newPack.origin.coordinate,
        destinationCoordinates: state.newPack.destination.coordinate,
        size: state.newPack.size,
      );

      setState(() {
        _recommendedPrice = _value;
      });
      _priceController =
          TextEditingController(text: _recommendedPrice.toString());
    } catch (error) {
      setState(() {
        _recommendedPrice.value = 0;
      });
    } finally {
      setState(() {
        _price = _recommendedPrice;
      });

      _priceController = TextEditingController(text: 0.toString());
    }
  }

  _createLot() async {
    if (_totalPriceValue < 0) {
      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).invalidPrice,
        AppLocalizations.of(context).pleaseCheckPriceValue,
      );
      return;
    }

    state.newPack.uid = _authService.currentUserId;

    state.newPack.price.currency = 'RUB';
    state.newPack.price.value = _totalPriceValue;

    state.newPack.distance = 10000;

    String _refId;

    try {
      _uiService.showActivityIndicator(context);

      final uploadedPhoto = await _uploadPhoto();

      if (uploadedPhoto != null) {
        state.newPack.photos = List<Photo>();
        state.newPack.photos.add(uploadedPhoto);
      }

      _refId = await _addPack();
    } catch (error) {
      _uiService.hideActivityIndicator(context, true);

      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).error,
        AppLocalizations.of(context).unableCreateItem,
      );

      return;
    }

    _uiService.hideActivityIndicator(context, true);

    _onCreated();
  }

  _onCreated() {
    StateWidget.of(context).resetNewPack();

    final _snackBar = SnackBar(
        content: Text(AppLocalizations.of(context).itemCreatedInPendingState));

    state.mainScaffoldKey.currentState.showSnackBar(_snackBar);

    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  Future<Photo> _uploadPhoto() async {
    if (state.newPack.picture == null) return null;

    Photo uploadedPhoto = await _uploadService.upload(state.newPack.picture);

    return uploadedPhoto;
  }

  Future<String> _addPack() async {
    final docRef = await _lotsService.addPack(state.newPack);

    return docRef.documentID;
  }
}
