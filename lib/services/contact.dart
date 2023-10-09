import 'package:flutter/cupertino.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/models/deal.dart';
import 'package:packedoo_app_material/models/pack.dart';
import 'package:packedoo_app_material/services/api.dart';
import 'package:packedoo_app_material/services/deals.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';
import 'package:packedoo_app_material/services/navigation.dart';
import 'package:packedoo_app_material/services/ui.dart';
import 'package:url_launcher/url_launcher.dart';

ContactService contactService = ContactService();

class ContactService {
  UIService _uiService = uiService;
  ApiService _apiService = apiService;
  DealsService _dealsService = dealsService;

  Future<void> showContactOptions(
    BuildContext context, {
    String phoneNo,
    bool phoneCallsAvailable,
    @required String dealId,
  }) {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(AppLocalizations.of(context).contactPerson),
        actions: <Widget>[
          if (phoneCallsAvailable)
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context).call),
              onPressed: () async {
                await makeCall(
                    context: context,
                    phoneNo: phoneNo,
                    requestPhone: true,
                    dealId: dealId);
                Navigator.pop(context);
              },
            ),
          CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context).contactSendMessage),
            onPressed: () async {
              final deal = await _getDeal(context, dealId);
              Navigator.of(context).pop();
              _toMessages(deal.id);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(AppLocalizations.of(context).cancel),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> showContactsForMyDeliveries(
    BuildContext context, {
    @required Pack pack,
    @required String dealId,
    bool phoneCallsAvailable,
    bool externalSender = false,
    bool externalReceiver = false,
  }) {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(AppLocalizations.of(context).contactPerson),
        actions: <Widget>[
          if (phoneCallsAvailable)
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context).callSender),
              onPressed: () async {
                await makeCall(
                    context: context,
                    phoneNo: null,
                    requestPhone: true,
                    dealId: dealId);
                Navigator.pop(context);
              },
            ),
          if (phoneCallsAvailable && !pack.sendingMyself && externalSender)
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context).callPersonToPickUpFrom),
              onPressed: () async {
                await makeCall(
                    context: context, phoneNo: pack.originContact?.phoneNumber);
                Navigator.pop(context);
              },
            ),
          if (phoneCallsAvailable && !pack.meetingMyself && externalReceiver)
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context).callRecipient),
              onPressed: () async {
                await makeCall(
                    context: context,
                    phoneNo: pack.destinationContact?.phoneNumber);
                Navigator.pop(context);
              },
            ),
          CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context).contactSendMessage),
            onPressed: () async {
              final deal = await _getDeal(context, dealId);
              Navigator.of(context).pop();
              _toMessages(deal.id);
              //
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(AppLocalizations.of(context).cancel),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  _toMessages(String dealId) {
    NavigationService.toDealMessages(dealId);
  }

  Future makeCall(
      {BuildContext context,
      String phoneNo,
      bool requestPhone = false,
      String dealId}) async {
    GoogleAnalytics().dealCall();

    if (requestPhone) {
      _uiService.showActivityIndicator(context);
      phoneNo = await _apiService.getPhone(dealId);
      _uiService.hideActivityIndicator(context, true);
    }

    if (phoneNo == null) {
      await _uiService.showInfoDialog(
          context, AppLocalizations.of(context).phoneNotDefined, '');
      return;
    }

    await _launch(context,
        url: 'tel:$phoneNo',
        errorMessage: AppLocalizations.of(context).unableToPerformCall);
  }

  Future<Deal> _getDeal(BuildContext context, String dealId) async {
    if (dealId == null) {
      await _uiService.showInfoDialog(
          context, AppLocalizations.of(context).dealNotDefined, '');
      return null;
    }

    Deal deal;
    try {
      _uiService.showActivityIndicator(context);
      deal = await _dealsService.getDeal(dealId);
      _uiService.hideActivityIndicator(context, true);
    } catch (e) {
      _uiService.hideActivityIndicator(context, true);
      _uiService.showInfoDialog(context, AppLocalizations.of(context).error,
          AppLocalizations.of(context).cantMakeRequest);
    }

    return deal;
  }

  Future _launch(BuildContext context,
      {String url, String errorMessage}) async {
    await canLaunch(url)
        ? await launch(url)
        : await _uiService.showInfoDialog(
            context, AppLocalizations.of(context).error, errorMessage);
  }
}
