import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:packedoo_app_material/models/packedoo_user.dart';
import 'package:packedoo_app_material/services/auth.dart';

class GoogleAnalytics {
  static final FirebaseAnalytics _instance = FirebaseAnalytics();
  final AuthService _authService = authService;

  logEvent({String name, Map<String, dynamic> params}) {
    _instance.logEvent(name: name, parameters: params);
  }

  setScreen(String name) {
    _instance.setCurrentScreen(screenName: name);
  }

  setUserId() {
    _instance.setUserId(_authService.currentUserId);
  }

  setUserProperties(PackedooUser user) {
    if (user == null) return;

    _instance.setUserProperty(name: 'admin', value: user.admin.toString());
    _instance.setUserProperty(
        name: 'sender',
        value: user.roles.contains((r) => r == 'sender').toString());
    _instance.setUserProperty(
        name: 'moover',
        value: user.roles.contains((r) => r == 'moover').toString());
  }

  logSearch() {
    _instance.logEvent(name: 'search');
  }

  reviewAdd() {
    _instance.logEvent(name: 'review_add');
  }

  filterSave() {
    _instance.logEvent(name: 'filter_save');
  }

  filterRemove() {
    _instance.logEvent(name: 'filter_remove');
  }

  profileSave({String type}) {
    _instance.logEvent(name: 'profile_save', parameters: {'type': type});
  }

  logIn({String method}) {
    _instance.logEvent(name: 'login', parameters: {'method': method});
  }

  logOut() {
    _instance.logEvent(name: 'logout');
  }

  signUp({String method}) {
    _instance.logEvent(name: 'sign_up', parameters: {'method': method});
  }

  lotArchive() {
    _instance.logEvent(name: 'lot_archive');
  }

  lotCreate() {
    _instance.logEvent(name: 'lot_create');
  }

  lotCreating({String step}) {
    _instance.logEvent(name: 'lot_creating', parameters: {'step': step});
  }

  lotEdit() {
    _instance.logEvent(name: 'lot_edit');
  }

  viewItem({String lotId}) {
    _instance.logEvent(name: 'view_item', parameters: {'lotId': lotId});
  }

  sendMessage() {
    _instance.logEvent(name: 'send_message');
  }

  upload() {
    _instance.logEvent(name: 'upload');
  }

  dealAccept() {
    _instance.logEvent(name: 'deal_accept');
  }

  dealApply() {
    _instance.logEvent(name: 'deal_apply');
  }

  dealBeginApply() {
    _instance.logEvent(name: 'deal_begin_apply');
  }

  dealCancel() {
    _instance.logEvent(name: 'deal_cancel');
  }

  dealCancelBegin() {
    _instance.logEvent(name: 'deal_cancel_begin');
  }

  dealCollect() {
    _instance.logEvent(name: 'deal_collect');
  }

  dealDecline() {
    _instance.logEvent(name: 'deal_decline');
  }

  dealDeliver() {
    _instance.logEvent(name: 'deal_deliver');
  }

  dealEnterCode({String source}) {
    _instance.logEvent(name: 'deal_enter_code', parameters: {'source': source});
  }

  dealRequestCode({String source}) {
    _instance
        .logEvent(name: 'deal_request_code', parameters: {'source': source});
  }

  dealCall() {
    _instance.logEvent(name: 'deal_call');
  }

  accountPhoneConfirmed({bool success}) {
    _instance.logEvent(
        name: 'account_phone_confirmed', parameters: {'success': success});
  }

  accountRequestPhoneConfirmation() {
    _instance.logEvent(name: 'account_request_phone_confirmation');
  }
}
