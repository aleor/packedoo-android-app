import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_locale/flutter_device_locale.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:packedoo_app_material/models/counters.dart';
import 'package:packedoo_app_material/models/filter.dart';
import 'package:packedoo_app_material/models/new_pack.dart';
import 'package:packedoo_app_material/models/packedoo_user.dart';
import 'package:packedoo_app_material/models/state.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/current_location.dart';
import 'package:packedoo_app_material/services/fcm.dart';
import 'package:packedoo_app_material/services/filters.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/users.dart';
import 'package:quiver/strings.dart';
import 'package:rxdart/subjects.dart';

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  static StateWidgetState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_StateDataWidget>())
        .data;
  }

  @override
  StateWidgetState createState() => new StateWidgetState();
}

class StateWidgetState extends State<StateWidget> {
  StateModel state;
  final _authService = authService;
  final _usersService = usersService;
  final _fcmService = fcmService;
  final _filtersService = filtersService;
  final _currentLocationService = currentLocationService;

  BehaviorSubject<Counters> _countersSubject = BehaviorSubject();
  BehaviorSubject<List<Filter>> _filtersSubject =
      BehaviorSubject<List<Filter>>();
  BehaviorSubject<Filter> _activeFilterSubject = BehaviorSubject<Filter>();

  Stream<Counters> get counters => _countersSubject.stream;
  Stream<List<Filter>> get filters => _filtersSubject.stream;
  Stream<Filter> get activeFilter => _activeFilterSubject.stream;
  List<Filter> get filtersValue => _filtersSubject.value;

  @override
  void initState() {
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = StateModel(isLoading: true);
      _initFirebaseUser();
      _fetchLocale();
    }

    _authService.userChanged.listen((FirebaseUser user) {
      _authService.updateCurrentUserId(user?.uid);
      _updateActiveUser(user);
      _enableListeners();
      _fcmService.writeFCMToken();
    });

    super.initState();
  }

  @override
  void dispose() {
    if (_countersSubject != null && !_countersSubject.isClosed) {
      _countersSubject.close();
    }
    super.dispose();
  }

  Future _initFirebaseUser() async {
    if (state.user.firebaseUser != null) {
      _setCurrentUser();
      return;
    }

    GoogleSignInAccount googleAccount =
        await _authService.getGoogleSignedInAccount();

    if (googleAccount != null) {
      await signInWithGoogle();

      _setCurrentUser();
    }

    setState(() {
      state.isLoading = false;
    });
  }

  Future _fetchLocale() async {
    final _deviceLocale = await DeviceLocale.getCurrentLocale();
    final _userLocale = state.user?.locale;

    final _defaultLocaleLang = _deviceLocale.languageCode ?? 'en';

    setState(() {
      state.locale = isNotEmpty(_userLocale)
          ? Locale(_userLocale)
          : Locale(_defaultLocaleLang);
    });
  }

  _enableListeners() {
    _listenCounters();
    _listenFilters();
  }

  _listenCounters() {
    _usersService.userCounters().listen((data) => {_countersSubject.add(data)});
  }

  _listenFilters() {
    _filtersService.getAll().listen((data) => {_filtersSubject.add(data)});
  }

  setActiveFilter(Filter filter) {
    _activeFilterSubject.add(filter);
  }

  resetActiveFilter() {
    _activeFilterSubject.add(null);
  }

  setPhone(String phone) {
    setState(() {
      state.user.phoneNumber = phone;
      state.user.phoneVerified = false;
    });
  }

  setDisplayName(String displayName) {
    setState(() {
      state.user.displayName = displayName;
    });
  }

  setPhotoUrl(String url) {
    setState(() {
      state.user.photoUrl = url;
    });
  }

  phoneConfirmed() {
    setState(() {
      state.user.phoneVerified = true;
    });
  }

  Future setLocale(Locale locale) async {
    setState(() {
      state.locale = locale;
    });

    _usersService.updateLocale(locale);

    final _location = await _currentLocationService
        .getMyLocationLocalized(locale.languageCode);
    state.currentLocation = _location;
  }

  Future<bool> signInWithGoogle() async {
    GoogleSignInAccount googleAccount;

    try {
      googleAccount = await _authService.googleSignIn();
    } catch (error) {
      print(error);
      return false;
    }

    FirebaseUser firebaseUser = (googleAccount == null)
        ? null
        : await _authService.signIntoFirebase(googleAccount);

    setState(() {
      state.user.firebaseUser = firebaseUser;
      state.isLoading = false;
    });

    _setCurrentUser();

    return true;
  }

  void resetUser() {
    setState(() {
      state.user = PackedooUser();
    });
  }

  void resetNewPack() {
    setState(() {
      state.newPack = NewPack();
    });
  }

  _updateActiveUser(FirebaseUser user) async {
    if (user == null) {
      resetUser();
      return;
    }

    await _setCurrentUser();
    await _fetchLocale();

    setState(() {
      state.user.firebaseUser = user;
      state.isLoading = false;
    });
  }

  _setCurrentUser() async {
    PackedooUser _userData = await _usersService.getCurrentUser();
    GoogleAnalytics().setUserId();
    GoogleAnalytics().setUserProperties(_userData);

    setState(() {
      state.user = _userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}
