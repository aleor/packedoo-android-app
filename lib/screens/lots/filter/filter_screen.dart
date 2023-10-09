import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/localizable_constants.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/filter.dart';
import 'package:packedoo_app_material/models/location.dart';
import 'package:packedoo_app_material/models/place_suggestion.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/google_places.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';
import 'package:quiver/strings.dart';

class FilterScreen extends StatefulWidget {
  final Filter currentFilter;

  const FilterScreen({Key key, this.currentFilter}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  GooglePlacesService _googlePlacesService = googlePlacesService;
  UIService _uiService = uiService;

  Location _originLocation;
  Location _destinationLocation;
  List<Location> _waypoints = [];

  StateWidgetState _state;
  StateModel _stateModel;

  Map<PackSize, bool> _sizeStatusMap = {
    PackSize.S: true,
    PackSize.M: true,
    PackSize.L: true,
    PackSize.XL: true,
    PackSize.XXL: true
  };

  SortOption _selectedSortOption = SortOption.Price;
  String _filterId;

  @override
  void initState() {
    GoogleAnalytics().setScreen('filter');
    _setFilterParams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _state = StateWidget.of(context);
    _stateModel = _state.state;

    return Scaffold(
      appBar: AppBar(title: Text(_screenTitle)),
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
                SizedBox(height: 10),
                _intermediatePoints(),
                _sizes(),
                _sortBy(),
                SizedBox(height: 30),
                _actionButton(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
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
            style: TextStyle(fontSize: 16),
          ),
        ),
        _chipInput(isOrigin: true),
        SizedBox(height: 10),
        _chipInput(isOrigin: false),
      ],
    );
  }

  Widget _chipFrom(bool isOrigin) {
    final _location = isOrigin ? _originLocation : _destinationLocation;

    if (_location == null) {
      return isOrigin
          ? Text(AppLocalizations.of(context).from)
          : Text(AppLocalizations.of(context).to);
    }

    final _avatarImg = isOrigin
        ? 'assets/images/blue_circle.png'
        : 'assets/images/red_circle.png';

    return InputChip(
      avatar: Image.asset(
        _avatarImg,
        width: 15,
        height: 15,
      ),
      backgroundColor: Colors.grey[300],
      label: Text(
        isEmpty(_location.city) ? _location.description : _location.city,
        style: TextStyle(fontSize: 16),
      ),
      onDeleted: () => _clearLocation(isOrigin),
    );
  }

  _clearLocation(bool isOrigin) {
    setState(() {
      isOrigin ? _originLocation = null : _destinationLocation = null;
    });
  }

  Widget _chipInput({bool isOrigin}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _selectLocation(isOrigin: isOrigin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              alignment: Alignment.centerLeft,
              height: 40,
              child: _chipFrom(isOrigin),
            ),
          ),
          Divider(thickness: 1, height: 1, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _intermediatePoints() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _selectLocation(
          isIntermediate: true,
          placeholder: AppLocalizations.of(context).intermediatePoint),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              alignment: Alignment.centerLeft,
              child: _getInterPoints(),
            ),
          ),
          Divider(thickness: 1, height: 1, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _getInterPoints() {
    if (_waypoints == null || _waypoints.length == 0)
      return Container(
          padding: EdgeInsets.only(top: 17, bottom: 13),
          child: Text(AppLocalizations.of(context).intermediatePoints));

    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: List<Widget>.generate(_waypoints.length, (index) {
        final _location = _waypoints[index];

        return InputChip(
          avatar: Image.asset(
            'assets/images/green_circle.png',
            width: 15,
            height: 15,
          ),
          backgroundColor: Colors.grey[300],
          label: Text(
            isEmpty(_location.city) ? _location.description : _location.city,
            style: TextStyle(fontSize: 14),
          ),
          onDeleted: () => _clearWaypoint(index),
        );
      }),
    );
  }

  Widget _sizes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 25, bottom: 10),
          child: Text(
            AppLocalizations.of(context).sizes,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Container(
          height: 50,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _sizeStatusMap.length,
              itemBuilder: (BuildContext context, int index) =>
                  _getSizeChipOption(
                      size: _sizeStatusMap.keys.elementAt(index))),
        ),
      ],
    );
  }

  Widget _sortBy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            AppLocalizations.of(context).sortBy,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Container(
          height: 50,
          child: ListView.builder(
              itemCount: SortOption.values.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) =>
                  _getSortByChipOption(
                      option: SortOption.values.elementAt(index))),
        ),
      ],
    );
  }

  Widget _actionButton() {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        color: Styles.kGreenColor,
        child: Text(
          AppLocalizations.of(context).findParcels.toUpperCase(),
          style: Styles.kButtonUpperTextStyle,
        ),
        onPressed: _applyFilter,
      ),
    );
  }

  Widget _getSizeChipOption({PackSize size}) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: FilterChip(
          backgroundColor: Colors.grey[300],
          checkmarkColor: _sizeStatusMap[size] ? Colors.white : Colors.black,
          label: Text(
            LocalizableConstants.getLotSize(
                context: context, sizeId: PackConstants.kSizeIdMap[size]),
            style: _sizeStatusMap[size]
                ? TextStyle(fontSize: 16, color: Colors.white)
                : TextStyle(fontSize: 16),
          ),
          selected: _sizeStatusMap[size],
          selectedColor: Styles.kGreenColor,
          onSelected: (bool value) {
            setState(() {
              _sizeStatusMap[size] = value;
            });
          }),
    );
  }

  Widget _getSortByChipOption({SortOption option}) {
    return Container(
      padding: EdgeInsets.only(right: 15),
      child: ChoiceChip(
          backgroundColor: Colors.grey[300],
          selectedColor: Styles.kGreenColor,
          shadowColor: Colors.green,
          selectedShadowColor: Colors.green[300],
          label: Text(
              LocalizableConstants.getSortOption(
                  context: context, option: option),
              style: _selectedSortOption == option
                  ? TextStyle(fontSize: 16, color: Colors.white)
                  : TextStyle(fontSize: 16)),
          selected: _selectedSortOption == option,
          onSelected: (value) {
            setState(() {
              _selectedSortOption = (value) ? option : null;
            });
          }),
    );
  }

  _clearWaypoint(int index) {
    if (index >= _waypoints.length) return;

    setState(() {
      _waypoints.removeAt(index);
    });
  }

  _selectLocation(
      {bool isOrigin, String placeholder, bool isIntermediate}) async {
    if (isIntermediate != null && isIntermediate) {
      isOrigin = false;
    }

    PlaceSuggestion suggestion = await NavigationService.toSelectLocation(
        isOrigin: isOrigin,
        placeholder: isNotEmpty(placeholder)
            ? placeholder
            : isOrigin
                ? AppLocalizations.of(context).from
                : AppLocalizations.of(context).to);

    if (suggestion == null) return;

    final _selectedLocation = suggestion.location ??
        await _googlePlacesService.locationDetails(suggestion.placeId,
            lang: _stateModel.lang);

    if (isIntermediate != null && isIntermediate) {
      setState(() {
        _waypoints.add(_selectedLocation);
      });

      return;
    }

    setState(() {
      isOrigin
          ? _originLocation = _selectedLocation
          : _destinationLocation = _selectedLocation;
    });
  }

  void _applyFilter() async {
    final _filter = await _composeFilter();

    if (_filter == null) return;

    _state.setActiveFilter(_filter);

    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  Future<Filter> _composeFilter() async {
    if (_sizeStatusMap.entries.every((item) => !item.value)) {
      await _uiService.showInfoDialog(
        context,
        AppLocalizations.of(context).sizesMissing,
        AppLocalizations.of(context).pleaseSelectAtLeastOneSize,
      );

      return null;
    }

    final _filterParams = Filter(
        origin: _originLocation,
        destination: _destinationLocation,
        sizes: _getBitwiseSizeValue(),
        sortBy: _selectedSortOption,
        waypoints: _waypoints);

    _filterParams.id = _filterId;
    _filterParams.allowedSizes = _sizeStatusMap;

    return _filterParams;
  }

  int _getBitwiseSizeValue() {
    final _allowedSizes = _sizeStatusMap.entries
        .where((entry) => entry.value)
        .map((entry) => PackConstants.kSizeIdMap[entry.key]);

    var _finalSize = _allowedSizes.reduce((s1, s2) => s1 | s2);

    return _finalSize;
  }

  _setFilterParams() {
    _sizeStatusMap = widget.currentFilter?.allowedSizes ?? _sizeStatusMap;
    _selectedSortOption = widget.currentFilter?.sortBy ?? _selectedSortOption;

    _originLocation = widget.currentFilter?.origin;
    _destinationLocation = widget.currentFilter?.destination;

    _waypoints = widget.currentFilter?.waypoints ?? [];

    _filterId = widget.currentFilter?.id;
  }

  String get _screenTitle => widget.currentFilter != null || _filterId != null
      ? _filterName
      : AppLocalizations.of(context).newRoute;

  String get _filterName {
    if (_originLocation == null && _destinationLocation == null) {
      return AppLocalizations.of(context).anyDirection;
    }

    var _origin = _originLocation != null
        ? isEmpty(_originLocation.city)
            ? _originLocation.description
            : _originLocation.city
        : null;

    var _destination = _destinationLocation != null
        ? isEmpty(_destinationLocation.city)
            ? _destinationLocation.description
            : _destinationLocation.city
        : null;

    if (_originLocation == null) {
      return AppLocalizations.of(context).toPoint + ': $_destination';
    }

    if (_destinationLocation == null) {
      return AppLocalizations.of(context).fromPoint + ': $_origin';
    }

    return '$_origin - $_destination';
  }
}
