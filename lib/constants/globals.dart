import 'package:flutter/cupertino.dart';

Globals globals = Globals();

class Globals {
  GlobalKey _scaffoldKey;
  Globals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}
