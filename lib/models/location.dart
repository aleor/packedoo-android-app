import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:packedoo_app_material/models/long_lat.dart';

class Location {
  String city;
  String country;
  String description;
  LongLat coordinate;
  String street;

  Location();

  Location.fromMap(Map<dynamic, dynamic> map) {
    city = map['city'] ?? '';
    country = map['country'];
    description = map['description'];
    street = map['street'];
    coordinate = LongLat.fromMap(map['coordinate']);
  }

  Location.fromPlaceDetails(PlaceDetails placeDetails) {
    this.description = placeDetails.formattedAddress;
    this.coordinate = LongLat(
      lat: placeDetails.geometry.location.lat,
      long: placeDetails.geometry.location.lng,
    );
    this.country = placeDetails.addressComponents
        ?.firstWhere((component) => component.types.contains('country'),
            orElse: () => null)
        ?.longName;
    this.street = placeDetails.addressComponents
        ?.firstWhere((component) => component.types.contains('route'),
            orElse: () => null)
        ?.longName;
    this.city = placeDetails.addressComponents
            ?.firstWhere((component) => component.types.contains('locality'),
                orElse: () => null)
            ?.longName ??
        _fallbackToArea(placeDetails);
  }

  String _fallbackToArea(PlaceDetails placeDetails) {
    return placeDetails.addressComponents
            ?.firstWhere(
                (component) =>
                    component.types.contains('administrative_area_level_3'),
                orElse: () => null)
            ?.longName ??
        '';
  }

  Location.fromPlacemark(Placemark placemark) {
    this.description =
        '${placemark.name}, ${placemark.locality}, ${placemark.country}';
    this.coordinate = LongLat(
      lat: placemark.position.latitude,
      long: placemark.position.longitude,
    );
    this.country = placemark.country;
    this.street = placemark.thoroughfare ?? placemark.subLocality;
    this.city = placemark.locality;
  }

  Map toMap() => {
        "description": this.description,
        "country": this.country,
        "city": this.city,
        "coordinate": this.coordinate.toMap()
      };
}
