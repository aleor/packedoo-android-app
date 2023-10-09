import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/contact.dart';
import 'package:packedoo_app_material/models/location.dart';
import 'package:packedoo_app_material/models/place_suggestion.dart';
import 'package:packedoo_app_material/models/price.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/screens/new_item/new_item_styles.dart';
import 'package:packedoo_app_material/screens/shared/action_progress_bar_widget.dart';
import 'package:packedoo_app_material/services/cost.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/google_places.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';

class NewItemThirdScreen extends StatefulWidget {
  @override
  _NewItemThirdScreenState createState() => _NewItemThirdScreenState();
}

class _NewItemThirdScreenState extends State<NewItemThirdScreen> {
  TextEditingController _originTextController = TextEditingController();
  TextEditingController _destinationTextController = TextEditingController();

  bool _sendingMyself = true;
  bool _meetingMyself = true;

  UIService _uiService = uiService;
  GooglePlacesService _googlePlacesService = googlePlacesService;
  CostService _costService = costService;

  Location _originLocation;
  Location _destinationLocation;

  Contact _originContact;
  Contact _destinationContact;

  Price _recommendedPrice;

  StateModel state;

  @override
  void initState() {
    GoogleAnalytics().setScreen('new_item_step_3');
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

  Widget _buildBody() {
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
                _route(),
                _sender(),
                _receiver(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _progressBar() {
    return ActionProgressBar(
      value: 0.75,
      handler: _toFourthStep,
    );
  }

  Widget _route() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, bottom: 5),
          child: Text(
            AppLocalizations.of(context).route,
            style: NewItemStyles.labelStyle,
          ),
        ),
        _locationField(isOrigin: true),
        _locationField(isOrigin: false),
      ],
    );
  }

  Widget _locationField({bool isOrigin}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _selectLocation(isOrigin: isOrigin),
      child: IgnorePointer(
        child: TextField(
          readOnly: true,
          maxLines: null,
          controller:
              isOrigin ? _originTextController : _destinationTextController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          decoration: InputDecoration(
              labelText: isOrigin
                  ? AppLocalizations.of(context).from
                  : AppLocalizations.of(context).to),
        ),
      ),
    );
  }

  Widget _sender() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              AppLocalizations.of(context).personToPickUpFrom,
              style: NewItemStyles.labelStyle,
            ),
          ),
          _person(
              isSending: true,
              isMyself: true,
              handler: () => _selectOriginContact(myself: true),
              label: AppLocalizations.of(context).meUpper),
          _person(
              isSending: true,
              isMyself: false,
              handler: () => _selectOriginContact(myself: false),
              label: AppLocalizations.of(context).anotherPerson),
        ],
      ),
    );
  }

  Widget _person(
      {@required bool isMyself,
      @required bool isSending,
      @required String label,
      Function handler}) {
    return Container(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: handler,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(child: Text(label)),
                  if (!isMyself) _getExternalPerson(isSending: isSending),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Radio(
                  value: isMyself,
                  groupValue: isSending ? _sendingMyself : _meetingMyself,
                  activeColor: Styles.kGreenColor,
                  onChanged: (bool value) => handler(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getExternalPerson({bool isSending}) {
    if (isSending && _originContact == null) {
      return Container();
    }

    if (!isSending && _destinationContact == null) {
      return Container();
    }

    final _contact = isSending ? _originContact : _destinationContact;

    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        children: <Widget>[
          Container(
            child: Expanded(
              child: Text(
                '${_contact.name}, ${_contact.phoneNumber}',
                style: TextStyle(color: Colors.black45),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _receiver() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              AppLocalizations.of(context).personToDeliver,
              style: NewItemStyles.labelStyle,
            ),
          ),
          _person(
              isSending: false,
              isMyself: true,
              handler: () => _selectDestinationContact(myself: true),
              label: AppLocalizations.of(context).meUpper),
          _person(
              isSending: false,
              isMyself: false,
              handler: () => _selectDestinationContact(myself: false),
              label: AppLocalizations.of(context).anotherPerson),
        ],
      ),
    );
  }

  _selectOriginContact({bool myself}) async {
    setState(() {
      _sendingMyself = myself;
    });

    if (_sendingMyself) {
      _originContact = null;
      return;
    }

    Contact externalSender = await NavigationService.toExternalContact(
        _originContact,
        header: AppLocalizations.of(context).sender);

    if (externalSender != null) {
      _originContact = externalSender;
    } else {
      if (_originContact == null) {
        setState(() {
          _sendingMyself = true;
        });
      }
    }
  }

  _selectDestinationContact({bool myself}) async {
    setState(() {
      _meetingMyself = myself;
    });

    if (_meetingMyself) {
      _destinationContact = null;
      return;
    }

    Contact externalReciever = await NavigationService.toExternalContact(
        _destinationContact,
        header: AppLocalizations.of(context).recipient);

    if (externalReciever != null) {
      _destinationContact = externalReciever;
    } else {
      if (_destinationContact == null) {
        setState(() {
          _meetingMyself = true;
        });
      }
    }
  }

  _selectLocation({bool isOrigin}) async {
    PlaceSuggestion suggestion =
        await NavigationService.toSelectLocation(isOrigin: isOrigin);

    if (suggestion == null) return;

    final _selectedLocation = suggestion.location ??
        await _googlePlacesService.locationDetails(suggestion.placeId,
            lang: state.lang);

    if (isOrigin) {
      _originLocation = _selectedLocation;
      _originTextController.text =
          _selectedLocation.description ?? suggestion.description;
    } else {
      _destinationLocation = _selectedLocation;
      _destinationTextController.text =
          _selectedLocation.description ?? suggestion.description;
    }

    _calculatePrice();
  }

  _calculatePrice() async {
    if (_destinationLocation != null && _originLocation != null) {
      try {
        _recommendedPrice = await _costService.calculate(
          originCoordinates: _originLocation.coordinate,
          destinationCoordinates: _destinationLocation.coordinate,
          size: state.newPack.size,
        );
      } catch (error) {}
    }
  }

  _toFourthStep() async {
    if (_originLocation == null || _destinationLocation == null) {
      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).missingRoute,
        AppLocalizations.of(context).pleaseSelectBothAddresses,
      );
      return;
    }

    state.newPack.sendingMyself = _sendingMyself;
    state.newPack.meetingMyself = _meetingMyself;

    state.newPack.originContact = _originContact;
    state.newPack.destinationContact = _destinationContact;

    state.newPack.origin = _originLocation;
    state.newPack.destination = _destinationLocation;

    NavigationService.toNewItemForthStep(recommendedPrice: _recommendedPrice);
  }
}
