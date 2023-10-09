import 'package:flutter/widgets.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';

class LocalizableConstants {
  static String getLotSize({BuildContext context, int sizeId}) {
    switch (sizeId) {
      case (1):
        return AppLocalizations.of(context).small;
      case (2):
        return AppLocalizations.of(context).medium;
      case (4):
        return AppLocalizations.of(context).large;
      case (8):
        return AppLocalizations.of(context).veryLarge;
      case (16):
        return AppLocalizations.of(context).xxl;
      default:
        return AppLocalizations.of(context).unknown;
    }
  }

  static String getSortOption({BuildContext context, SortOption option}) {
    switch (option) {
      case (SortOption.Price):
        return AppLocalizations.of(context).price;
      case (SortOption.Date):
        return AppLocalizations.of(context).date;
      case (SortOption.Distance):
        return AppLocalizations.of(context).distance;
      default:
        return AppLocalizations.of(context).unknown;
    }
  }

  static String getStatusName({BuildContext context, int statusId}) {
    switch (statusId) {
      case (1):
        return AppLocalizations.of(context).pendingLotStatus;
      case (2):
        return AppLocalizations.of(context).waitingForPickup;
      case (3):
        return AppLocalizations.of(context).inDelivery;
      case (4):
        return AppLocalizations.of(context).delivered;
      case (5):
        return AppLocalizations.of(context).deliveryConfirmed;
      case (6):
        return AppLocalizations.of(context).cancelled;
      case (7):
        return AppLocalizations.of(context).declined;
      default:
        return AppLocalizations.of(context).unknown;
    }
  }
}
