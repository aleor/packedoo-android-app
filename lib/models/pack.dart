import 'package:intl/intl.dart';
import 'package:packedoo_app_material/converters/datetime_converter.dart';
import 'package:packedoo_app_material/models/base_pack_info.dart';
import 'package:packedoo_app_material/models/contact.dart';
import 'package:packedoo_app_material/models/packedoo_user.dart';
import 'package:packedoo_app_material/models/price.dart';

class Pack extends BasePackInfo {
  final int number;
  final DateTime createdOn;
  final bool meetingMyself;
  final bool sendingMyself;
  final Price price;
  final PackedooUser sender;
  final Contact originContact;
  final Contact destinationContact;
  final int pendingCount;
  final bool hasSenderReview;

  String get originDescription => '${origin.city}, ${origin.country}';
  String get destinationDescription =>
      '${destination.city}, ${destination.country}';
  String get distanceInKm => '${(distance / 1000).round()}';
  String get desiredDateFormatted =>
      DateFormat("EEE, MMM d, yyyy").format(desiredDate);
  String get desiredDateDDMMYYY => DateFormat("d.MM.yyyy").format(desiredDate);
  String get createdOnDDMMYYY => DateFormat("d.MM.yyyy").format(createdOn);
  String get desiredDateMMMDYYYY =>
      DateFormat("MMM d, yyyy").format(desiredDate);

  Pack.fromMap(Map<String, dynamic> map, String documentId)
      : number = map['number'],
        createdOn = DateTimeConverter.fromTimestamp(map['createdOn']),
        meetingMyself = map['meetingMyself'],
        sendingMyself = map['sendingMyself'],
        hasSenderReview = map['hasSenderReview'] ?? false,
        price = Price.fromMap(map['price']),
        sender = map['sender'] != null
            ? PackedooUser.fromMap(map['sender'])
            : PackedooUser(),
        originContact = map['originContact'] != null
            ? Contact.fromMap(map['originContact'])
            : Contact(),
        destinationContact = map['destinationContact'] != null
            ? Contact.fromMap(map['destinationContact'])
            : Contact(),
        pendingCount = map['pendingCount'],
        super.fromMap(map, documentId);
}
