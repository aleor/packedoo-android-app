import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';

final AuthService authService = AuthService();

class AuthService {
  GoogleSignInAccount _googleAccount;
  final GoogleSignIn _googleSignIn = new GoogleSignIn(scopes: ['email']);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _userId;

  Stream<FirebaseUser> get userChanged => _firebaseAuth.onAuthStateChanged;
  String get currentUserId => _userId;

  Future<String> getFirebaseIdToken() async {
    final _currentUser = await _firebaseAuth.currentUser();
    return (await _currentUser.getIdToken(refresh: true)).token;
  }

  updateCurrentUserId(String uid) {
    _userId = uid;
  }

  Future _firebaseSignOut() {
    return _firebaseAuth.signOut();
  }

  Future<GoogleSignInAccount> getGoogleSignedInAccount() async {
    _googleAccount = _googleSignIn.currentUser;

    // if there is no currently logged in user,
    // we could try to login a previously authenticated one
    if (_googleAccount == null) {
      try {
        _googleAccount =
            await _googleSignIn.signInSilently(suppressErrors: true);
      } on PlatformException {}
    }

    return _googleAccount;
  }

  Future<FirebaseUser> signIntoFirebase(
      GoogleSignInAccount googleSignInAccount) async {
    if (googleSignInAccount == null) {
      return null;
    }
    GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser firebaseUser =
        (await _firebaseAuth.signInWithCredential(credential)).user;

    return firebaseUser;
  }

  Future<GoogleSignInAccount> googleSignIn() {
    GoogleAnalytics().logIn(method: 'Google');
    return _googleSignIn.signIn();
  }

  Future<GoogleSignInAccount> _googleLogOut() {
    return _googleSignIn.signOut();
  }

  // this one doesn't work so far and there is an issue on gitHub :-|
  void clearStoredAccounts() {
    try {
      _googleSignIn.disconnect();
    } on PlatformException {
      print('Could not disconnect google account');
    }
  }

  Future<FirebaseUser> createFirebaseUser(
      {String email, String password}) async {
    FirebaseUser _firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password))
        .user;

    updateCurrentUserId(_firebaseUser?.uid);

    return _firebaseUser;
  }

  Future<bool> signInWithEmailAndPassword(
      {String email, String password}) async {
    GoogleAnalytics().logIn(method: 'e-mail');

    final _firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    updateCurrentUserId(_firebaseUser?.uid);

    return _firebaseUser != null;
  }

  Future logout() async {
    GoogleAnalytics().logOut();

    if (_googleSignIn.currentUser != null) {
      await _googleLogOut();
    }

    if (await _firebaseAuth.currentUser() != null) {
      await _firebaseSignOut();
    }
  }
}
