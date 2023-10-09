import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/filter.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/filters.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';

class AllFiltersScreen extends StatefulWidget {
  @override
  _AllFiltersScreenState createState() => _AllFiltersScreenState();
}

class _AllFiltersScreenState extends State<AllFiltersScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  StateWidgetState _state;
  StreamSubscription _filtersSubscription;
  FiltersService _filtersService = filtersService;
  List<Filter> _filters;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) => _listenFilters());
    super.initState();
  }

  @override
  void dispose() {
    _filtersSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _state = StateWidget.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(AppLocalizations.of(context).changeRoutes)),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_filters == null) {
      return Center(child: CustomCircularIndicator());
    }

    if (_filters.length == 0) {
      return Center(
          child: Text(AppLocalizations.of(context).youDontHaveSavedRoutesYet));
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _filters.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildRoute(context, index)),
      ),
    );
  }

  Widget _buildRoute(BuildContext context, int index) {
    final route = _filters[index];
    return Container(
      height: 50,
      child: ListTile(
        leading: Icon(Icons.timeline),
        trailing: _getActionButtons(
          deleteCallback: () => _deleteFilter(route),
          editCallback: () => _editFilter(route),
        ),
        title: Text(route.getName(context)),
        onTap: () => _applyRoute(route),
      ),
    );
  }

  _listenFilters() {
    _filtersSubscription = _state.filters.listen((data) => setState(() {
          _filters = data;
        }));
  }

  _applyRoute(Filter route) {
    Navigator.of(context).pop();
    _state.setActiveFilter(route);
  }

  Widget _getActionButtons({Function deleteCallback, Function editCallback}) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(icon: Icon(Icons.edit), onPressed: editCallback),
          IconButton(icon: Icon(Icons.delete), onPressed: deleteCallback),
        ],
      ),
    );
  }

  _deleteFilter(Filter route) async {
    if (route == null) {
      return;
    }

    await _filtersService.delete(filterId: route.id);

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context).routeRemoved),
    ));
  }

  _editFilter(Filter route) {
    NavigationService.toFilter(currentFilter: route);
  }
}
