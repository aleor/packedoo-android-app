import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/models/counters.dart';
import 'package:packedoo_app_material/models/filter.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/services/images.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';

class SideMenu extends StatefulWidget {
  final MenuItem activeItem;

  const SideMenu({Key key, this.activeItem}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final ImageService _imageService = imageService;

  StateWidgetState _state;
  StateModel _stateModel;
  StreamSubscription _countersSubscription;
  StreamSubscription _filtersSubscription;
  Counters _counters;
  List<Filter> _filters = List<Filter>();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) => _enableListeners());
    super.initState();
  }

  @override
  void dispose() {
    _countersSubscription?.cancel();
    _filtersSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _state = StateWidget.of(context);
    _stateModel = _state.state;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Styles.kGreenColor,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _toProfile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _photo(),
                  _name(),
                  _account(),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.list,
              color: _iconColorFor(MenuItem.AllItems),
            ),
            title: Text(
              AppLocalizations.of(context).allPacks,
              style: _textStyleFor(MenuItem.AllItems),
            ),
            onTap: _toAllItems,
          ),
          ListTile(
            leading: Icon(
              Icons.send,
              color: _iconColorFor(MenuItem.SendNew),
            ),
            title: Text(
              AppLocalizations.of(context).sendPack,
              style: _textStyleFor(MenuItem.SendNew),
            ),
            onTap: _toCreateNew,
          ),
          ListTile(
            leading: Icon(
              Icons.airport_shuttle,
              color: _iconColorFor(MenuItem.MyItems),
            ),
            title: _getMyItemsWithCounter(),
            onTap: _toMyItems,
          ),
          ListTile(
            leading: Icon(
              Icons.forum,
              color: _iconColorFor(MenuItem.Messages),
            ),
            title: _getMessagesWithCounter(),
            onTap: _toAllChats,
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: _iconColorFor(MenuItem.Profile),
            ),
            title: Text(
              AppLocalizations.of(context).profile,
              style: _textStyleFor(MenuItem.Profile),
            ),
            onTap: _toProfile,
          ),
          Divider(),
          _savedRoutesArea(),
        ],
      ),
    );
  }

  Widget _photo() {
    return Container(
      height: 60,
      width: 60,
      child: _getUserAvatar(),
    );
  }

  Widget _getUserAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: _imageService.getNetworkImageOrPlaceholder(
        imageUrl: _stateModel.user.photoUrl ?? '',
        placeholder: 'assets/images/default_user.png',
      ),
    );
  }

  Widget _name() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Text(
        _stateModel.user.safeUserName,
        style: TextStyle(color: Colors.white, fontSize: 24),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _account() {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Text(
        _stateModel.user.email,
        style: TextStyle(color: Colors.white, fontSize: 16),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _savedRoutesArea() {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).routes,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                if (_filters?.isNotEmpty)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _toAllRoutes,
                    child: Container(
                      child: Text(AppLocalizations.of(context).change,
                          style: TextStyle(color: Colors.grey[600])),
                    ),
                  ),
              ],
            ),
          ),
          if (_filters?.isEmpty) _noSavedRoutesMsg(),
          ListView.builder(
              padding: EdgeInsets.only(top: 10),
              shrinkWrap: true,
              itemCount: _filters.length,
              itemBuilder: (BuildContext context, int index) =>
                  _buildRoute(context, index)),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildRoute(BuildContext context, int index) {
    final route = _filters[index];
    return Container(
      height: 40,
      child: ListTile(
        dense: true,
        leading: Icon(Icons.timeline),
        title: Text(route.getName(context)),
        onTap: () => _applyRoute(route),
      ),
    );
  }

  Widget _noSavedRoutesMsg() {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 16, right: 16),
      child: Text(
        AppLocalizations.of(context).youDontHaveSavedRoutesYet,
        style: TextStyle(color: Colors.grey[500]),
      ),
    );
  }

  Widget _getMessagesWithCounter() {
    return Row(
      children: <Widget>[
        Text(
          AppLocalizations.of(context).messages,
          style: _textStyleFor(MenuItem.Messages),
        ),
        _getCounter(_counters?.totalMessages),
      ],
    );
  }

  Widget _getMyItemsWithCounter() {
    return Row(
      children: <Widget>[
        Text(
          AppLocalizations.of(context).myItems,
          style: _textStyleFor(MenuItem.MyItems),
        ),
        _getCounter(_counters?.suggestionCount),
      ],
    );
  }

  Widget _getCounter(int value) {
    if (value == null || value == 0) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: Container(
          padding: EdgeInsets.all(3),
          child: Container(
            padding: const EdgeInsets.only(left: 2, right: 2),
            child: Text(
              '$value',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
          ),
          color: Color(0xffee5d69),
        ),
      ),
    );
  }

  _enableListeners() {
    _listenCounters();
    _listenFilters();
  }

  _listenCounters() {
    _countersSubscription = _state.counters.listen((data) => setState(() {
          _counters = data;
        }));
  }

  _listenFilters() {
    _filtersSubscription = _state.filters.listen((data) => setState(() {
          _filters = data;
        }));
  }

  Color _iconColorFor(MenuItem item) =>
      item == widget.activeItem ? Styles.kGreenColor : null;

  TextStyle _textStyleFor(MenuItem item) =>
      item == widget.activeItem ? TextStyle(color: Styles.kGreenColor) : null;

  _toProfile() {
    Navigator.of(context).pop();
    NavigationService.toUserProfile();
  }

  _toAllItems() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  _toMyItems() {
    Navigator.of(context).pop();
    NavigationService.toMyItems();
  }

  _toAllChats() {
    Navigator.of(context).pop();
    NavigationService.toAllChats();
  }

  _toCreateNew() {
    Navigator.of(context).pop();
    NavigationService.toCreateNew();
  }

  _applyRoute(Filter route) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
    _state.setActiveFilter(route);
  }

  _toAllRoutes() {
    Navigator.of(context).pop();
    NavigationService.toAllRoutes();
  }
}
