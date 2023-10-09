import 'dart:ui';

import 'package:packedoo_app_material/constants/enums.dart';

abstract class PackConstants {
  static const Map<PackSize, int> kSizeIdMap = {
    PackSize.Unknown: 0,
    PackSize.S: 1,
    PackSize.M: 2,
    PackSize.L: 4,
    PackSize.XL: 8,
    PackSize.XXL: 16
  };

  static const Map<PackSize, String> kShortSizeNameMap = {
    PackSize.S: 'S',
    PackSize.M: 'M',
    PackSize.L: 'L',
    PackSize.XL: 'XL',
    PackSize.XXL: 'XXL'
  };

  static const Map<SortOption, int> kSortOptionIdMap = {
    SortOption.Price: 1,
    SortOption.Distance: 2,
    SortOption.Date: 4
  };

  static const Map<int, SortOption> kIdSortOptionMap = {
    1: SortOption.Price,
    2: SortOption.Distance,
    4: SortOption.Date
  };

  static const Map<Lang, String> kLangStringMap = {
    Lang.RU: 'Русский',
    Lang.EN: 'English'
  };

  static Map<Locale, Lang> kLocaleLangIdMap = {
    Locale('ru'): Lang.RU,
    Locale('en'): Lang.EN
  };

  static Map<Locale, String> kLocaleLangValueMap = {
    Locale('ru'): kLangStringMap[kLocaleLangIdMap[Locale('ru')]],
    Locale('en'): kLangStringMap[kLocaleLangIdMap[Locale('en')]],
  };

  static Map<Lang, Locale> kLangLocaleMap = {
    Lang.RU: Locale('ru'),
    Lang.EN: Locale('en')
  };

  static const Map<ChatType, String> kChatTypeNameMap = {
    ChatType.Deals: 'deals',
    ChatType.Users: 'users',
  };

  static List<String> get kSupportedCountries =>
      kCountryIsoCodeMap.values.toList();

  static Map<Country, String> kCountryIsoCodeMap = {
    Country.RU: 'RU',
    Country.BY: 'BY',
    Country.UA: 'UA',
    Country.CZ: 'CZ',
    Country.DE: 'DE',
  };

  static Map<String, Country> kIsoCodeCountryMap = {
    'RU': Country.RU,
    'BY': Country.BY,
    'UA': Country.UA,
    'CZ': Country.CZ,
    'DE': Country.DE,
  };

  static Map<Country, int> kCountryMobileLength = {
    Country.RU: 11,
    Country.BY: 12,
    Country.UA: 12,
    Country.CZ: 12,
    Country.DE: 13,
  };

  static const double kPickerSheetHeight = 216.0;
  static const double kPickerItemHeight = 32.0;

  static const kMaxDeliveryMessageLength = 256;

  static Map<Status, int> statusIdMap = {
    Status.PENDING: 1,
    Status.ACCEPTED: 2,
    Status.IN_PROGRESS: 3,
    Status.DELIVERED: 4,
    Status.CONFIRMED: 5,
    Status.CANCELED: 6,
    Status.DECLINED: 7
  };

  static Map<int, Status> idStatusMap = {
    1: Status.PENDING,
    2: Status.ACCEPTED,
    3: Status.IN_PROGRESS,
    4: Status.DELIVERED,
    5: Status.CONFIRMED,
    6: Status.CANCELED,
    7: Status.DECLINED
  };

  // keys moved to env params
  static const String kGoogleApiKey = 'key-moved-to-env-params';

  static const String kPackedooWebEn = 'https://packedoo.com';
  static const String kPackedooWebRu = 'https://packedoo.ru';
  static const String kPackedooDev = 'link-to-dev-env-moved-to-env-params';

  static String getPackedooWeb({Locale locale, bool isDev}) {
    if (isDev) return kPackedooDev;

    if (PackConstants.kLocaleLangIdMap[locale] == Lang.RU)
      return kPackedooWebRu;

    return kPackedooWebEn;
  }
}
