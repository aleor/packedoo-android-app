import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/new_pack.dart';
import 'package:packedoo_app_material/models/packedoo_user.dart';

class StateModel {
  bool isLoading;
  PackedooUser user;
  NewPack newPack;
  List<Placemark> currentLocation;
  Locale locale;
  GlobalKey<ScaffoldState> _mainScaffoldKey;

  String get userId => user?.firebaseUser?.uid;

  GlobalKey<ScaffoldState> get mainScaffoldKey => this._mainScaffoldKey;

  String get lang {
    return locale == PackConstants.kLangLocaleMap[Lang.RU] ? 'ru' : 'en';
  }

  StateModel({this.isLoading = false, this.user}) {
    this.newPack = NewPack();
    this.user = PackedooUser();
    this._mainScaffoldKey = GlobalKey<ScaffoldState>();
  }
}
