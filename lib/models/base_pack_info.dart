import 'package:intl/intl.dart';
import 'package:packedoo_app_material/converters/datetime_converter.dart';
import 'package:packedoo_app_material/models/location.dart';
import 'package:packedoo_app_material/models/photo.dart';

class BasePackInfo {
  final String id;
  final String name;
  final DateTime desiredDate;
  final int distance;
  final int status;
  final String uid;
  final List<Photo> photos;
  final Location destination;
  final Location origin;
  final String description;
  final int sizeId;

  String get originDescription => '${origin.city}, ${origin.country}';
  String get destinationDescription =>
      '${destination.city}, ${destination.country}';
  String get distanceInKm => '${(distance / 1000).round()}';
  String get desiredDateFormatted =>
      DateFormat("EEE, MMM d, yyyy").format(desiredDate);
  String get desiredDateDDMMYYY => DateFormat("d.MM.yyyy").format(desiredDate);
  String get desiredDateMMMDYYYY =>
      DateFormat("MMM d, yyyy").format(desiredDate);

  BasePackInfo.fromMap(Map<dynamic, dynamic> map, String lotId)
      : id = lotId,
        name = map['name'] ?? '',
        desiredDate = DateTimeConverter.fromTimestamp(map['date']),
        distance = map['distance'],
        status = map['status'],
        uid = map['uid'],
        photos = map['photos'] != null
            ? (map['photos'] as List).map((p) {
                return Photo.fromMap(p);
              }).toList()
            : List<Photo>(),
        destination = Location.fromMap(map['destination']) ?? '',
        origin = Location.fromMap((map['origin'])) ?? '',
        description = map['description'] ?? '',
        sizeId = map['size'];
}
