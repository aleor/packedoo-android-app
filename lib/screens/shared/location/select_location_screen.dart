import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/location.dart';
import 'package:packedoo_app_material/models/place_suggestion.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/services/google_places.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';

class SelectLocationScreen extends StatefulWidget {
  final bool isOrigin;
  final String title;
  final String placeholder;

  const SelectLocationScreen(
      {Key key, this.isOrigin, this.title, this.placeholder})
      : super(key: key);

  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  StateModel state;
  UIService _uiService = uiService;
  GooglePlacesService _googlePlacesService = googlePlacesService;
  List<PlaceSuggestion> suggestions = [];

  @override
  Widget build(BuildContext context) {
    state = StateWidget.of(context).state;

    return Scaffold(
      appBar: AppBar(
        title: _searchField(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.location_searching),
            onPressed: _getMyLocation,
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
        child: ListView.builder(
      itemBuilder: _itemBuilder,
      itemCount: suggestions.length,
    ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final _suggestion = suggestions[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _returnSuggestion(_suggestion),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                      child: Text(
                        _suggestion.mainText,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 6),
                      child: Text(
                        _suggestion.secondaryText,
                        style: TextStyle(
                          color: Styles.kGreyTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 42, right: 10),
          child: Container(
            height: 1,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _searchField() {
    return Container(
      child: TextField(
        decoration: InputDecoration(hintText: _searchHintText),
        autocorrect: false,
        autofocus: true,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        onChanged: _getSuggestions,
      ),
    );
  }

  _getSuggestions(String input) async {
    final list =
        await _googlePlacesService.suggestions(input, lang: state.lang);
    setState(() {
      suggestions = list;
    });
  }

  _getMyLocation() async {
    if (state.currentLocation != null && state.currentLocation.first != null) {
      _getSuggestionFromPlacemark(state.currentLocation.first);
      return;
    }

    final _geolocator = Geolocator();
    final _permissions = LocationPermissions();

    List<Placemark> _places = [];
    PermissionStatus permission = await _permissions.checkPermissionStatus(
        level: LocationPermissionLevel.locationWhenInUse);

    if (permission != PermissionStatus.granted) {
      PermissionStatus granted = await _permissions.requestPermissions(
          permissionLevel: LocationPermissionLevel.locationWhenInUse);

      if (granted != PermissionStatus.granted) {
        await _uiService.showInfoDialog(
          context,
          AppLocalizations.of(context).missingPermissions,
          AppLocalizations.of(context).geolocationAccessRequired,
        );
        return;
      }
    }

    try {
      _uiService.showActivityIndicator(context);

      Position position = await _geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _places = await _geolocator.placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: state.lang);
      state.currentLocation = _places;
      _uiService.hideActivityIndicator(context, true);
    } catch (error) {
      _uiService.hideActivityIndicator(context, true);

      await _uiService.showInfoDialog(
          context,
          AppLocalizations.of(context).error,
          AppLocalizations.of(context).currentLocationUnknown);
      return;
    }

    if (_places.isNotEmpty) {
      _getSuggestionFromPlacemark(_places.first);
      return;
    }

    _uiService.showInfoDialog(
        context, '', AppLocalizations.of(context).currentLocationUnknown);
  }

  _returnSuggestion(PlaceSuggestion suggestion) {
    Navigator.of(context).pop(suggestion);
  }

  _getSuggestionFromPlacemark(Placemark placemark) {
    final _currentLocation = Location.fromPlacemark(placemark);
    final _suggestion = PlaceSuggestion.withLocation(_currentLocation);

    _returnSuggestion(_suggestion);
  }

  String get _searchHintText =>
      widget.placeholder != null && widget.placeholder.isNotEmpty
          ? widget.placeholder
          : widget.isOrigin
              ? AppLocalizations.of(context).pickUpItemFrom
              : AppLocalizations.of(context).deliverItemTo;
}
