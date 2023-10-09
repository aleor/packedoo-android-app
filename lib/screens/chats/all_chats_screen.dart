import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/latest_message.dart';
import 'package:packedoo_app_material/screens/chats/deal_latest_message_row.dart';
import 'package:packedoo_app_material/screens/shared/custom_circular_indicator_widget.dart';
import 'package:packedoo_app_material/screens/shared/custom_drawer_widget.dart';
import 'package:packedoo_app_material/screens/shared/side_menu_widget.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/messages.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/styles.dart';

class AllChatsScreen extends StatefulWidget {
  @override
  _AllChatsScreenState createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  MessagesService _messagesService = messagesService;
  List<LatestMessage> _activeItems = [];
  List<LatestMessage> _archivedItems = [];
  LatestMessage _systemChatLastMessage;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    GoogleAnalytics().setScreen('all_chats');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(activeItem: MenuItem.Messages),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).messages),
        leading: CustomDrawer(scaffoldKey: _scaffoldKey),
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
        stream: _messagesService.getMyLastMessages(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CustomCircularIndicator(),
            );

          if (snapshot.data.documents.isEmpty) return _noDealsMessage();

          _setDealMessages(snapshot.data.documents);
          _setUserMessages(snapshot.data.documents);

          return _buildDealsLists();
        });
  }

  _buildDealsLists() {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) =>
          _expandableListView(index: index),
    );
  }

  Widget _expandableListView({int index}) {
    return index == 0 ? _getActiveItemsList() : _getArchivedItemsList();
  }

  Widget _getActiveItemsList() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _getPackedooChat(),
          Column(
              children: _activeItems
                  .map((message) => DealLatestMessageRow(
                      latestMessage: message,
                      isLast: _activeItems.last == message,
                      onTapHandler: _toDealMessages))
                  .toList()),
        ],
      ),
    );
  }

  Widget _getArchivedItemsList() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: ExpansionTile(
        initiallyExpanded: false,
        title: Text(AppLocalizations.of(context).archivedItems,
            style: TextStyle(fontSize: 20, color: Colors.black)),
        children: _archivedItems
            .map((message) => DealLatestMessageRow(
                latestMessage: message,
                isLast: _archivedItems.last == message,
                onTapHandler: _toDealMessages))
            .toList(),
      ),
    );
  }

  Widget _noDealsMessage() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          AppLocalizations.of(context).youDoNotHaveAnyDeals,
          textAlign: TextAlign.center,
          style: TextStyle(color: Styles.kGreyTextColor),
        ),
      ),
    );
  }

  Widget _getPackedooChat() {
    if (_systemChatLastMessage == null) return Container();

    return DealLatestMessageRow(
        latestMessage: _systemChatLastMessage,
        fromPackedoo: true,
        onTapHandler: _toDealMessages,
        isLast: _activeItems?.length == 0);
  }

  void _setDealMessages(List<DocumentSnapshot> documents) {
    final _dealsMessages = List<LatestMessage>.from(
            documents.map((document) => LatestMessage.fromMap(document.data)))
        .where((m) =>
            m.chatType == PackConstants.kChatTypeNameMap[ChatType.Deals]);

    _activeItems = _dealsMessages
        .where(
            (m) => m.dealStatus <= PackConstants.statusIdMap[Status.DELIVERED])
        .toList();

    _archivedItems = _dealsMessages
        .where(
            (m) => m.dealStatus > PackConstants.statusIdMap[Status.DELIVERED])
        .toList();
  }

  void _setUserMessages(List<DocumentSnapshot> documents) {
    _systemChatLastMessage = documents
        .map((document) => LatestMessage.fromMap(document.data))
        .firstWhere(
            (d) => d.chatType == PackConstants.kChatTypeNameMap[ChatType.Users],
            orElse: () => null);
  }

  _toDealMessages(String dealId, {bool fromPackedoo = false}) {
    NavigationService.toDealMessages(dealId, fromPackedoo: fromPackedoo);
  }
}
