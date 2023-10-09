import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:packedoo_app_material/models/counters.dart';
import 'package:packedoo_app_material/state_widget.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomDrawer({Key key, @required this.scaffoldKey}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  StateWidgetState _state;
  StreamSubscription _countersSubscription;
  Counters _counters;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) => _listenCounters());
    super.initState();
  }

  @override
  void dispose() {
    if (_countersSubscription != null) {
      _countersSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _state = StateWidget.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.scaffoldKey.currentState.openDrawer(),
      child: Stack(children: [
        Center(child: Icon(Icons.dehaze)),
        if (_counters != null && _counters.pendingTotal != 0)
          Positioned(
            left: 32,
            bottom: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Container(
                padding: EdgeInsets.all(2),
                child: _getCounter(),
                color: Color(0xffee5d69),
              ),
            ),
          )
      ]),
    );
  }

  Widget _getCounter() {
    if (_counters == null || _counters.pendingTotal == 0) {
      return Container();
    }

    final _counterValue = _counters.pendingTotal < 10
        ? ' ${_counters.pendingTotal} '
        : '${_counters.pendingTotal}';

    return Text(
      _counterValue,
      style: TextStyle(
          color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
    );
  }

  _listenCounters() {
    _countersSubscription = _state.counters.listen((data) => setState(() {
          _counters = data;
        }));
  }
}
