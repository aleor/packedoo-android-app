import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/screens/my_items/deliveries/my_deliveries_screen.dart';
import 'package:packedoo_app_material/screens/my_items/sendings/my_sendings_screen.dart';
import 'package:packedoo_app_material/screens/shared/custom_drawer_widget.dart';
import 'package:packedoo_app_material/screens/shared/side_menu_widget.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/styles.dart';

class MyItemsScreen extends StatefulWidget {
  @override
  _MyItemsScreenState createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    GoogleAnalytics().setScreen('my_sendings');
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(activeItem: MenuItem.MyItems),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).myItems),
        leading: CustomDrawer(scaffoldKey: _scaffoldKey),
        bottom: TabBar(
          tabs: _getTabs(),
          controller: _tabController,
          indicatorColor: Styles.kGreenColor,
          labelColor: Colors.black,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MySendingsScreen(),
          MyDeliveriesScreen(),
        ],
      ),
    );
  }

  List<Tab> _getTabs() {
    return [
      Tab(text: AppLocalizations.of(context).sending.toUpperCase()),
      Tab(text: AppLocalizations.of(context).delivering.toUpperCase())
    ];
  }
}
