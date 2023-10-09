import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:packedoo_app_material/models/counters.dart';
import 'package:packedoo_app_material/models/new_user.dart';
import 'package:packedoo_app_material/models/packedoo_user.dart';
import 'package:packedoo_app_material/models/user_statistics.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';

UsersService usersService = UsersService();

class UsersService {
  final AuthService _authService = authService;
  static final Firestore _firestore = Firestore.instance;

  final _usersStore = _firestore.collection('users');
  final _statsStore = _firestore.collection('statistics');
  final _countersStore = _firestore.collection('counters');

  Future createNewUser(NewUser newUser) async {
    GoogleAnalytics().signUp(method: 'e-mail');

    FirebaseUser _firebaseUser = await _authService.createFirebaseUser(
        email: newUser.email, password: newUser.password);

    await _fillUserData(newUser, _firebaseUser.uid);
  }

  Future<PackedooUser> getUser(String uid) async {
    final documentSnapshot = await _usersStore.document(uid).get();

    return documentSnapshot.exists
        ? PackedooUser.fromMap(documentSnapshot.data)
        : null;
  }

  Future _fillUserData(NewUser user, String userId) async {
    final _userData = {
      'displayName': '${user.firstName} ${user.lastName}',
      'photoURL': user.photoURL != null ? user.photoURL : null,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'locale': user.locale,
      'phoneNumber': user.phoneNumber,
      'email': user.email,
    };

    await _usersStore.document(userId).setData(_userData, merge: true);

    return Completer().complete();
  }

  Future<bool> isPhoneVerified({String userId}) async {
    final _user = await getUser(userId ?? _authService.currentUserId);

    return _user == null ? false : _user.phoneVerified;
  }

  Future<String> getPhoneNumber({String userId}) async {
    final _userData =
        await _usersStore.document(userId ?? _authService.currentUserId).get();

    return _userData?.data == null ? null : _userData.data['phoneNumber'];
  }

  Future<bool> hasPhoneNumber() async {
    final _phoneNumber = await getPhoneNumber();

    return _phoneNumber != null && _phoneNumber.isNotEmpty;
  }

  Future addPhoneNumber(String phoneNumber) async {
    GoogleAnalytics().profileSave(type: 'phone');

    await _usersStore
        .document(_authService.currentUserId)
        .setData({'phoneNumber': phoneNumber}, merge: true);
  }

  Future writeFCMToken(String token) async {
    if (_authService.currentUserId == null) {
      return;
    }

    var _pushTokenKey = Platform.isAndroid ? 'androidPushToken' : 'apnToken';

    await _usersStore
        .document(_authService.currentUserId)
        .setData({_pushTokenKey: token}, merge: true);
  }

  Future<PackedooUser> getCurrentUser() async {
    return getUser(_authService.currentUserId);
  }

  Future updateLocale(Locale locale) async {
    if (locale == null) return;

    await _usersStore
        .document(_authService.currentUserId)
        .setData({'locale': locale.languageCode}, merge: true);
  }

  Future updatePhoto(String url) async {
    GoogleAnalytics().profileSave(type: 'photo');

    await _usersStore
        .document(_authService.currentUserId)
        .setData({'photoURL': url}, merge: true);
  }

  Future<UserStatistics> getUserStats(String userId) async {
    final documentSnapshot = await _statsStore.document(userId).get();

    return documentSnapshot.exists
        ? UserStatistics.fromMap(documentSnapshot.data)
        : null;
  }

  Stream<Counters> userCounters({String userId}) {
    final _userId = userId ?? _authService.currentUserId;

    if (_userId == null) return null;

    return _countersStore
        .document(_userId)
        .snapshots()
        .map((s) => Counters.fromMap(s.data));
  }

  Future updateAboutMe(String about) async {
    GoogleAnalytics().profileSave(type: 'aboutMe');

    await _usersStore
        .document(_authService.currentUserId)
        .setData({'aboutMe': about}, merge: true);
  }
}
