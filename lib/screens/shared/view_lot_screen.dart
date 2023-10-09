import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/contact.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/screens/shared/carousel/carousel_widget.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/screens/shared/external_contact_infobar_widget.dart';
import 'package:packedoo_app_material/screens/shared/registered_user_infobar_widget.dart';
import 'package:packedoo_app_material/screens/shared/route_info_widget.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/lots.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewLotScreen extends StatefulWidget {
  final String lotId;
  final bool isMy;
  final bool actionsEnabled;

  const ViewLotScreen(
      {Key key,
      @required this.lotId,
      this.actionsEnabled = true,
      this.isMy = false})
      : super(key: key);

  @override
  _ViewLotScreenState createState() => _ViewLotScreenState();
}

class _ViewLotScreenState extends State<ViewLotScreen> {
  final LotsService _lotsService = lotsService;
  final UIService _uiService = uiService;

  StateModel _state;
  Pack _lot;

  @override
  void initState() {
    GoogleAnalytics().setScreen('view_lot');
    _loadLot();
    super.initState();
  }

  Future _loadLot() async {
    var _lotData = await _lotsService.getPack(widget.lotId);
    setState(() {
      _lot = _lotData;
    });
  }

  @override
  Widget build(BuildContext context) {
    _state = StateWidget.of(context).state;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.isMy
              ? AppLocalizations.of(context).yourParcel
              : AppLocalizations.of(context).offer),
          actions: _getActions(),
        ),
        floatingActionButton:
            (!widget.isMy && widget.actionsEnabled) ? _continueButton() : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: _lot == null
            ? Center(child: CustomCircularIndicator())
            : _buildBody());
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _carousel(),
            _infoSection(),
          ],
        ),
      ),
    );
  }

  Widget _carousel() {
    return Container(
      child: Carousel(
        children: _lot.photos,
        title: _lot.name,
        height: 220,
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
          _datesRow(),
          _description(),
          _route(),
          _partiesInfo(),
          SizedBox(height: 80)
        ],
      ),
    );
  }

  Widget _title() {
    return Container(
      child: Text(
        _lot.name,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _datesRow() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _deliveryUntil(),
          _createdOn(),
        ],
      ),
    );
  }

  Widget _deliveryUntil() {
    return Container(
      child: Text('${AppLocalizations.of(context).deliveryUntil}: $_dateUntil'),
    );
  }

  Widget _createdOn() {
    return Container(
      child: Text(
          '${AppLocalizations.of(context).createdOn}: ${_lot.createdOnDDMMYYY}',
          style: TextStyle(color: Colors.grey)),
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
            child: isEmpty(_lot.description)
                ? Text(AppLocalizations.of(context).noAdditionalDescription)
                : Text(_lot.description),
          )
        ],
      ),
    );
  }

  Widget _route() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).route,
            style: TextStyle(color: Styles.kGreenColor),
          ),
          RouteInfo(lot: _lot),
        ],
      ),
    );
  }

  Widget _partiesInfo() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _senderInfo(),
          if (!_lot.sendingMyself && _lot.originContact != null)
            _getSendingPerson(),
          if (!_lot.meetingMyself && _lot.destinationContact != null)
            _getRecievingPerson(),
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
            child: RegisteredUserInfoBar(user: _lot.sender),
          ),
        ],
      ),
    );
  }

  Widget _getSendingPerson() {
    return Container(
      padding: EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).pickUpPerson,
            style: TextStyle(color: Styles.kGreenColor),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ExternalContactInfoBar(
                contact: Contact(
                  name: _lot.originContact.name,
                  phoneNumber: AppLocalizations.of(context).phoneNumberHidden,
                ),
                handler: _showNoPhoneDialog),
          ),
        ],
      ),
    );
  }

  Widget _getRecievingPerson() {
    return Container(
      padding: EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).recipient,
            style: TextStyle(color: Styles.kGreenColor),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ExternalContactInfoBar(
              contact: Contact(
                name: _lot.destinationContact.name,
                phoneNumber: AppLocalizations.of(context).phoneNumberHidden,
              ),
              handler: _showNoPhoneDialog,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getActions() {
    List<Widget> _actions = [];

    if (widget.isMy) {
      _actions.add(Center(
          child: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: _showBottomSheet,
      )));
    }

    return _actions;
  }

  Widget _continueButton() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 12, left: 16, right: 16),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        color: Styles.kGreenColor,
        child: Text(
          AppLocalizations.of(context).continueUpper,
          style: Styles.kButtonUpperTextStyle,
        ),
        onPressed: _offerDeal,
      ),
    );
  }

  String get _dateUntil => _lot.desiredDate != null
      ? _lot.desiredDateDDMMYYY
      : AppLocalizations.of(context).anyDate;

  _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 120,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text(AppLocalizations.of(context).editViaWeb),
                  onTap: () {
                    Navigator.of(context).pop();
                    _editViaWeb();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text(AppLocalizations.of(context).toDelete),
                  onTap: () {
                    Navigator.of(context).pop();
                    _deleteLot();
                  },
                ),
              ],
            ));
      },
    );
  }

  _editViaWeb() async {
    GoogleAnalytics().lotEdit();

    final _localizedWeb =
        PackConstants.getPackedooWeb(locale: _state.locale, isDev: false);
    final url = '$_localizedWeb/edit/${widget.lotId}';

    await launch(url);
  }

  _deleteLot() async {
    var confirmed = await _uiService.showConfirmationDialog(
        context,
        AppLocalizations.of(context).removal,
        AppLocalizations.of(context).allOffersWillBeDeleted,
        declineActionText: AppLocalizations.of(context).cancel);

    if (!confirmed) return;

    _uiService.showActivityIndicator(context);
    try {
      await _lotsService.remove(widget.lotId);
    } catch (e) {
      _uiService.hideActivityIndicator(context, true);
      _uiService.showInfoDialog(context, AppLocalizations.of(context).error,
          AppLocalizations.of(context).cantMakeRequest);
      return;
    }

    _uiService.hideActivityIndicator(context, true);
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  void _showNoPhoneDialog() {
    _uiService.showInfoDialog(
      context,
      AppLocalizations.of(context).externalContact,
      AppLocalizations.of(context).phoneNumberHiddenUntilDealAccepted,
    );
  }

  _offerDeal() {
    NavigationService.toOfferDeal(lot: _lot);
  }
}
