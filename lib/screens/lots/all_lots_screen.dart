import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/models/filter.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/models/packedoo_user.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/screens/lots/filter/filter_panel.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/screens/shared/custom_drawer_widget.dart';
import 'package:packedoo_app_material/screens/shared/side_menu_widget.dart';
import 'package:packedoo_app_material/services/filters.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/lots.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/users.dart';
import 'package:packedoo_app_material/state_widget.dart';
import 'package:packedoo_app_material/styles.dart';
import 'lot_card_item.dart';

class AllLotsScreen extends StatefulWidget {
  const AllLotsScreen({Key key}) : super(key: key);

  @override
  _AllLotsScreenState createState() => _AllLotsScreenState();
}

class _AllLotsScreenState extends State<AllLotsScreen> {
  final UsersService _usersService = usersService;
  final LotsService _lotsService = lotsService;
  final FiltersService _filtersService = filtersService;

  ScrollController _scrollController = ScrollController();
  bool _floatingHeaderVisible = true;

  Filter _appliedFilter;

  StateWidgetState _state;
  StateModel _stateModel;

  PackedooUser _user;
  List<Pack> _packs;
  bool _isLoading = true;

  @override
  void initState() {
    GoogleAnalytics().setScreen('all_lots');
    _loadUser();
    _fetchLots();
    _enableScrollListener();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _listenActiveFilter());
    super.initState();
  }

  Future _loadUser() async {
    final _userData = await _usersService.getCurrentUser();
    setState(() {
      _user = _userData;
    });
  }

  _enableScrollListener() {
    _scrollController.addListener(() {
      setState(() {
        _floatingHeaderVisible =
            _scrollController.position.userScrollDirection ==
                    ScrollDirection.forward ||
                (_packs != null && _packs.length <= 3);
      });
    });
  }

  _listenActiveFilter() {
    _state.activeFilter.listen((data) => _onNewFilterApplied(data));
  }

  _onNewFilterApplied(Filter filter) {
    setState(() {
      _appliedFilter = filter;
      _isLoading = true;
    });
    _fetchLots();
  }

  @override
  Widget build(BuildContext context) {
    _state = StateWidget.of(context);
    _stateModel = _state.state;

    if (_user == null) {
      return Scaffold(
        body: Center(child: CustomCircularIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitle),
        leading: CustomDrawer(scaffoldKey: _stateModel.mainScaffoldKey),
        actions: _actionButtons,
      ),
      key: _stateModel.mainScaffoldKey,
      drawer: SideMenu(activeItem: MenuItem.AllItems),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NavigationService.toCreateNew(),
        child: Icon(Icons.add),
        backgroundColor: Styles.kGreenColor,
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CustomCircularIndicator());
    }

    if (_packs == null) {
      return Center(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            AppLocalizations.of(context).searchErrorPleaseCheckParams,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchLots,
      child: Stack(
        children: [
          CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(
                    top: _floatingHeaderVisible ? _floatingHeaderHeight : 0),
                sliver: _packs.length == 0
                    ? SliverToBoxAdapter(child: _itemsCountHeader)
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => index == 0
                              ? Column(
                                  children: <Widget>[
                                    _itemsCountHeader,
                                    LotCardItem(pack: _packs[index]),
                                  ],
                                )
                              : LotCardItem(pack: _packs[index]),
                          childCount: _packs.length,
                        ),
                      ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: SizedBox(height: 20),
              )
            ],
          ),
          if (_appliedFilter != null)
            Container(
              height: _floatingHeaderVisible ? _floatingHeaderHeight : 0,
              child: _floatingHeader,
            ),
        ],
      ),
    );
  }

  Future _fetchLots() async {
    final _lots = _appliedFilter != null
        ? await _filtersService.apply(filter: _appliedFilter)
        : await _lotsService.fetchLotsWithStatus(Status.PENDING);

    setState(() {
      _packs = _lots;
      _isLoading = false;
    });
  }

  Widget get _itemsCountHeader => Container(
        color: Colors.white,
        padding: EdgeInsets.only(
            top: _appliedFilter != null ? 5 : 15,
            bottom: 10,
            left: 16,
            right: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                _itemsFoundText,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      );

  Widget get _floatingHeader => FilterPanel(filter: _appliedFilter);

  List<Widget> get _actionButtons {
    return [
      if (_appliedFilter != null)
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => _state.resetActiveFilter(),
        ),
      IconButton(
        icon: Icon(Icons.search),
        onPressed: _toFilter,
      ),
    ];
  }

  _toFilter() => NavigationService.toFilter(currentFilter: _appliedFilter);

  String _getPlural(int count) {
    if (count == 1) return AppLocalizations.of(context).option;

    if (count > 1 && count <= 4)
      return AppLocalizations.of(context).optionsOneToFour;

    return AppLocalizations.of(context).optionsFourAndMore;
  }

  String get _itemsFoundText {
    return _packs.length == 0
        ? AppLocalizations.of(context).noAvailableItems
        : AppLocalizations.of(context).weHaveFound +
            ' ${_packs.length} ${_getPlural(_packs.length)}';
  }

  double get _floatingHeaderHeight => _appliedFilter != null ? 85 : 0;

  String get _screenTitle => _appliedFilter != null
      ? _appliedFilter.getName(context)
      : AppLocalizations.of(context).allPacks;
}
