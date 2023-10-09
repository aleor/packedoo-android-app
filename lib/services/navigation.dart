import 'package:flutter/material.dart';
import 'package:packedoo_app_material/models/contact.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/models/filter.dart';
import 'package:packedoo_app_material/models/new_user.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/models/price.dart';
import 'package:packedoo_app_material/screens/chats/all_chats_screen.dart';
import 'package:packedoo_app_material/screens/chats/deal_messages_screen.dart';
import 'package:packedoo_app_material/screens/deals/cancel_offer_screen.dart';
import 'package:packedoo_app_material/screens/deals/pending_deal_to_sender_screen.dart';
import 'package:packedoo_app_material/screens/login/email_login_screen.dart';
import 'package:packedoo_app_material/screens/login/register_via_email_screen.dart';
import 'package:packedoo_app_material/screens/login/user_created_screen.dart';
import 'package:packedoo_app_material/screens/lots/filter/all_filters_screen.dart';
import 'package:packedoo_app_material/screens/lots/filter/filter_screen.dart';
import 'package:packedoo_app_material/screens/lots/offer_deal_screen.dart';
import 'package:packedoo_app_material/screens/my_items/deliveries/active_delivery_screen.dart';
import 'package:packedoo_app_material/screens/my_items/my_items_screen.dart';
import 'package:packedoo_app_material/screens/my_items/sendings/accepted_deal_screen.dart';
import 'package:packedoo_app_material/screens/my_items/sendings/in_delivery_deal_screen.dart';
import 'package:packedoo_app_material/screens/my_items/sendings/my_sendings_offers_screen.dart';
import 'package:packedoo_app_material/screens/new_item/new_item_first_screen.dart';
import 'package:packedoo_app_material/screens/new_item/new_item_forth_screen.dart';
import 'package:packedoo_app_material/screens/new_item/new_item_second_screen.dart';
import 'package:packedoo_app_material/screens/new_item/new_item_third_screen.dart';
import 'package:packedoo_app_material/screens/new_item/select_external_contact_screen.dart';
import 'package:packedoo_app_material/screens/profile/about_screen.dart';
import 'package:packedoo_app_material/screens/profile/about_user_screen.dart';
import 'package:packedoo_app_material/screens/profile/edit_phone_screen.dart';
import 'package:packedoo_app_material/screens/profile/languages_screen.dart';
import 'package:packedoo_app_material/screens/profile/settings_screen.dart';
import 'package:packedoo_app_material/screens/profile/user_profile_screen.dart';
import 'package:packedoo_app_material/screens/shared/add_phone_screen.dart';
import 'package:packedoo_app_material/screens/shared/confirm_phone_screen.dart';
import 'package:packedoo_app_material/screens/shared/deal_review_screen.dart';
import 'package:packedoo_app_material/screens/shared/location/select_location_screen.dart';
import 'package:packedoo_app_material/screens/shared/registered_user_profile.dart';
import 'package:packedoo_app_material/screens/shared/reviews_screen.dart';
import 'package:packedoo_app_material/screens/shared/view_lot_screen.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  static toLotViewScreen(
      {@required String lotId,
      @required bool isMy,
      bool actionsEnabled = true,
      bool isModal = true}) {
    GoogleAnalytics().viewItem(lotId: lotId);

    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => ViewLotScreen(
          lotId: lotId,
          isMy: isMy,
          actionsEnabled: actionsEnabled,
        ),
        fullscreenDialog: isModal,
      ),
    );
  }

  static toDealMessages(String dealId,
      {bool fromPackedoo = false, bool hasDrawer = false}) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => DealMessagesScreen(
          dealId: dealId,
          fromPackedoo: fromPackedoo,
          hasDrawer: hasDrawer,
        ),
      ),
    );
  }

  static toInactiveDealMessages(Deal deal) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => DealMessagesScreen(
          deal: deal,
        ),
      ),
    );
  }

  static replaceWithDealMessages(String dealId,
      {bool fromPackedoo = false, bool hasDrawer = false}) {
    navigatorKey.currentState.pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => DealMessagesScreen(
          dealId: dealId,
          fromPackedoo: fromPackedoo,
          hasDrawer: hasDrawer,
        ),
      ),
    );
  }

  static toRegisteredUserProfile(String userId, {bool dialog = true}) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            RegisteredUserProfile(userId: userId),
        fullscreenDialog: dialog,
      ),
    );
  }

  static toCancelDeal(Deal deal, {bool dialog = true}) {
    GoogleAnalytics().dealCancelBegin();

    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => CancelOfferScreen(deal: deal),
        fullscreenDialog: dialog,
      ),
    );
  }

  static toConfirmPhone({bool dialog = true}) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => ConfirmPhoneScreen(),
        fullscreenDialog: dialog,
      ),
    );
  }

  static toEmailLogin() {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => EmailLoginScreen(),
      ),
    );
  }

  static toEmailRegistration() {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => RegisterViaEmailScreen(),
      ),
    );
  }

  static toUserCreated(NewUser user) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => UserCreatedScreen(user: user),
      ),
    );
  }

  static toPendingDealScreen(Deal deal) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => PendingDealToSender(deal: deal),
      ),
    );
  }

  static toAddPhone({bool dialog = true}) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => AddPhoneScreen(),
        fullscreenDialog: dialog,
      ),
    );
  }

  static replaceWithAddPhone({bool dialog = true}) {
    navigatorKey.currentState.pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => AddPhoneScreen(),
        fullscreenDialog: dialog,
      ),
    );
  }

  static replaceWithActiveDelivery(String dealId) {
    navigatorKey.currentState.pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => ActiveDeliveryScreen(
          dealId: dealId,
        ),
      ),
    );
  }

  static toActiveDelivery(String dealId) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => ActiveDeliveryScreen(
          dealId: dealId,
        ),
      ),
    );
  }

  static replaceWithDealReview(String lotId, {@required bool isSender}) {
    navigatorKey.currentState.pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            DealReviewScreen(packId: lotId, isSender: isSender),
      ),
    );
  }

  static toDealReview(String lotId, {@required bool isSender}) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            DealReviewScreen(packId: lotId, isSender: isSender),
      ),
    );
  }

  static toNewItemSecondStep() {
    GoogleAnalytics().lotCreating(step: 'step_2');
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => NewItemSecondScreen(),
      ),
    );
  }

  static toNewItemThirdStep() {
    GoogleAnalytics().lotCreating(step: 'step_3');

    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => NewItemThirdScreen(),
      ),
    );
  }

  static toNewItemForthStep({@required Price recommendedPrice}) {
    GoogleAnalytics().lotCreating(step: 'step_4');

    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            NewItemForthScreen(recommendedPrice: recommendedPrice),
      ),
    );
  }

  static toSettings() {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => SettingsScreen(),
      ),
    );
  }

  static toAbout() {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => AboutScreen(),
      ),
    );
  }

  static toLanguages() {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => LanguagesScreen(),
      ),
    );
  }

  static toReviews(String userId, {bool dialog = true}) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (context) => ReviewsScreen(userId: userId),
        fullscreenDialog: dialog,
      ),
    );
  }

  static Future<dynamic> toExternalContact(Contact contact,
      {@required String header, bool dialog = true}) {
    return navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => SelectExternalContact(
          contact: contact,
          header: header,
        ),
        fullscreenDialog: dialog,
      ),
    );
  }

  static toEditPhone({String phoneNumber, @required bool isVerified}) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (context) => EditPhoneScreen(
          phoneNr: phoneNumber,
          isVerified: isVerified,
        ),
      ),
    );
  }

  static Future<dynamic> toSelectLocation(
      {@required bool isOrigin, String placeholder, bool dialog = true}) {
    return navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            SelectLocationScreen(isOrigin: isOrigin, placeholder: placeholder),
        fullscreenDialog: dialog,
      ),
    );
  }

  static toOfferDeal({@required Pack lot}) {
    GoogleAnalytics().dealBeginApply();

    navigatorKey.currentState.push(
      MaterialPageRoute(
          builder: (BuildContext context) => OfferDealScreen(lot: lot)),
    );
  }

  static toUserProfile() {
    navigatorKey.currentState.push(
      MaterialPageRoute(builder: (BuildContext context) => UserProfile()),
    );
  }

  static toMyItems() {
    navigatorKey.currentState
        .push(MaterialPageRoute(builder: (context) => MyItemsScreen()));
  }

  static toAllChats() {
    navigatorKey.currentState
        .push(MaterialPageRoute(builder: (context) => AllChatsScreen()));
  }

  static toCreateNew() {
    GoogleAnalytics().lotCreating(step: 'step_1');

    navigatorKey.currentState
        .push(MaterialPageRoute(builder: (context) => NewItemFirstScreen()));
  }

  static toMySendingsOffers(Pack lot) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => MySendingsOffersScreen(
          pack: lot,
        ),
      ),
    );
  }

  static toAcceptedDeal(Pack lot) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => AcceptedDealScreen(
          lot: lot,
        ),
      ),
    );
  }

  static toInDeliveryDeal(Pack lot) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => InDeliveryDealScreen(
          pack: lot,
        ),
      ),
    );
  }

  static Future<dynamic> toFilter({Filter currentFilter}) {
    return navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            FilterScreen(currentFilter: currentFilter),
        fullscreenDialog: true,
      ),
    );
  }

  static Future<bool> toAboutUserInfo(String currentInfo) {
    return navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (BuildContext context) => AboutUserScreen(
          about: currentInfo,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  static toAllRoutes() {
    navigatorKey.currentState.push(
      MaterialPageRoute(builder: (BuildContext context) => AllFiltersScreen()),
    );
  }
}
