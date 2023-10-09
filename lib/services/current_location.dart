import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:packedoo_app_material/state_widget.dart';

CurrentLocationService currentLocationService = CurrentLocationService();

class CurrentLocationService {
  Future<List<Placemark>> getLocationSilently(String lang) async {
    final _geolocator = Geolocator();
    final _permissions = LocationPermissions();

    List<Placemark> _places = [];
    PermissionStatus permission = await _permissions.checkPermissionStatus(
        level: LocationPermissionLevel.locationWhenInUse);

    if (permission != PermissionStatus.granted) {
      PermissionStatus granted = await _permissions.requestPermissions(
          permissionLevel: LocationPermissionLevel.locationWhenInUse);

      if (granted != PermissionStatus.granted) {
        Crashlytics.instance.log('User denied location permissions');
        return null;
      }
    }

    try {
      Position position = await _geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _places = await _geolocator.placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: lang);
    } on PlatformException catch (error) {
      Crashlytics.instance
          .log('${error.code} - ${error.message} - ${error.details}');
    }

    return _places;
  }

  Future storeLocationSilently(BuildContext context) async {
    final location =
        await this.getLocationSilently(StateWidget.of(context).state.lang);

    StateWidget.of(context).state.currentLocation = location;
  }

  Future<List<Placemark>> getMyLocationLocalized(String lang) async {
    return await this.getLocationSilently(lang);
  }
}
