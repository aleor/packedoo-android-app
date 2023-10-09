import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/filter.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/services/filters.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';

class FilterPanel extends StatefulWidget {
  final Filter filter;

  const FilterPanel({Key key, this.filter}) : super(key: key);

  @override
  _FilterPanelState createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  FiltersService _filtersService = filtersService;
  StateWidgetState _state;
  StateModel _stateModel;
  bool _filterSaved = false;
  Filter _appliedFilter;
  StreamSubscription _filterSub;

  @override
  void initState() {
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _listenActiveFilter());
    super.initState();
  }

  @override
  void deactivate() {
    _filterSub?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    _appliedFilter = widget.filter;
    _state = StateWidget.of(context);
    _stateModel = _state.state;

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
        child: Column(
          children: <Widget>[
            _saveRouteButton(),
            _saveRouteInfoMsg(),
          ],
        ),
      ),
    );
  }

  Widget _saveRouteButton() {
    return Container(
      child: OutlineButton(
        highlightColor: Colors.grey[200],
        highlightedBorderColor: Colors.grey,
        borderSide: BorderSide(color: _activeColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              _filterSaved ? Icons.favorite : Icons.favorite_border,
              size: 20,
              color: _activeColor,
            ),
            Container(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                _filterSaved
                    ? AppLocalizations.of(context).routeSaved
                    : AppLocalizations.of(context).saveRoute,
                style:
                    TextStyle(color: _activeColor, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        onPressed: () {
          setState(() {
            _filterSaved = !_filterSaved;
          });
          _updateFilter();
          _showSnack();
        },
      ),
    );
  }

  Widget _saveRouteInfoMsg() {
    if (_filterSaved)
      return Container(
        child: Text(
          AppLocalizations.of(context)
              .youWillGetNotificationsOnNewParcelsAlongRoute,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      );

    return Container(
      child: Text(
        AppLocalizations.of(context).saveRouteInfoMessage,
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
      ),
    );
  }

  _listenActiveFilter() {
    _filterSub = _state.activeFilter.listen((data) {
      _onNewFilterApplied();
    });
  }

  _onNewFilterApplied() {
    final _savedFilter = _state.filtersValue.firstWhere(
        (filter) => filter.equalTo(_appliedFilter),
        orElse: () => null);

    setState(() {
      _filterSaved = _savedFilter != null;
      _appliedFilter.id = _savedFilter?.id;
    });
  }

  _showSnack() {
    final _message = _filterSaved
        ? AppLocalizations.of(context).routeSavedAndAvailableInSidePanel
        : AppLocalizations.of(context).routeRemoved;

    _stateModel.mainScaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(_message),
    ));
  }

  _updateFilter() async {
    _filterSaved ? await _saveFilter() : await _removeFilter();
  }

  _saveFilter() async {
    GoogleAnalytics().filterSave();
    try {
      final _docId = await _filtersService.save(filter: _appliedFilter);
      setState(() {
        _appliedFilter.id = _docId;
      });
    } catch (e) {
      _stateModel.mainScaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).unableToSaveFilter)));
      return;
    }
  }

  _removeFilter() async {
    GoogleAnalytics().filterRemove();
    await _filtersService.delete(filterId: _appliedFilter?.id);
  }

  Color get _activeColor => _filterSaved ? _savedColor : _greyColor;
  Color get _greyColor => Colors.grey[600];
  Color get _savedColor => Styles.kGreenColor;
}
