import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:packedoo_app_material/app_locales.dart';
import 'package:packedoo_app_material/constants/enums.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/location.dart';
import 'package:quiver/strings.dart';

class Filter {
  String id;
  Location origin;
  Location destination;
  List<Location> waypoints;
  SortOption sortBy;
  int sizes;
  bool along = true;
  bool notifications = true;
  bool local = false;
  double radius;
  String uid;
  Map<PackSize, bool> allowedSizes;

  Filter(
      {this.origin, this.destination, this.sizes, this.sortBy, this.waypoints});

  Filter.fromMap(Map<String, dynamic> map, String documentId)
      : id = documentId,
        origin = map['origin'] != null ? Location.fromMap(map['origin']) : null,
        destination = map['destination'] != null
            ? Location.fromMap(map['destination'])
            : null,
        waypoints = map['waypoints'] != null
            ? (map['waypoints'] as List)
                .map((w) => Location.fromMap(w))
                .toList()
            : List<Location>(),
        sortBy = PackConstants.kIdSortOptionMap[map['sortBy']],
        sizes = map['sizes'],
        along = map['along'],
        notifications = map['notifications'],
        local = map['local'],
        radius =
            map['radius'] != null ? double.parse(map['radius'].toString()) : 0,
        allowedSizes = {
          PackSize.S:
              (map['sizes'] & PackConstants.kSizeIdMap[PackSize.S]) != 0,
          PackSize.M:
              (map['sizes'] & PackConstants.kSizeIdMap[PackSize.M]) != 0,
          PackSize.L:
              (map['sizes'] & PackConstants.kSizeIdMap[PackSize.L]) != 0,
          PackSize.XL:
              (map['sizes'] & PackConstants.kSizeIdMap[PackSize.XL]) != 0,
          PackSize.XXL:
              (map['sizes'] & PackConstants.kSizeIdMap[PackSize.XXL]) != 0,
        };

  Map<String, dynamic> toMap() {
    return {
      'origin': this.origin != null ? this.origin.toMap() : null,
      'destination': this.destination != null ? this.destination.toMap() : null,
      'along': this.along,
      'notifications': this.notifications,
      'sortBy': PackConstants.kSortOptionIdMap[this.sortBy],
      'sizes': this.sizes,
      'local': false,
      'waypoints': _getWaypoints(this.waypoints),
      'uid': this.uid
    };
  }

  String getName(BuildContext context) {
    if (this.origin == null && this.destination == null) {
      return AppLocalizations.of(context).anyDirection;
    }

    if (this.origin == null) {
      return AppLocalizations.of(context).toPoint + ': $destinationDescription';
    }

    if (this.destination == null) {
      return AppLocalizations.of(context).fromPoint + ': $originDescription';
    }

    return this.waypoints.isNotEmpty
        ? '$originDescription ... $destinationDescription'
        : '$originDescription - $destinationDescription';
  }

  String get originDescription => this.origin != null
      ? isNotEmpty(this.origin.city)
          ? this.origin.city
          : this.origin.description
      : null;

  String get destinationDescription => this.destination != null
      ? isNotEmpty(this.destination.city)
          ? this.destination.city
          : this.destination.description
      : null;

  bool equalTo(Filter other) {
    final _eq = this.origin?.coordinate?.lat == other.origin?.coordinate?.lat &&
        this.destination?.coordinate?.long ==
            other.destination?.coordinate?.long &&
        listEquals(this.waypoints, other.waypoints);

    return _eq;
  }

  _getWaypoints(List<Location> waypoints) {
    if (waypoints == null) return null;

    final res = waypoints.map((w) => w.toMap()).toList();

    return res;
  }
}
