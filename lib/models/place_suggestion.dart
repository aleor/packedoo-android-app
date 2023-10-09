import 'package:google_maps_webservice/places.dart' as google;
import 'package:packedoo_app_material/models/location.dart';

class PlaceSuggestion {
  String mainText;
  String secondaryText;
  String description;
  String placeId;

  Location location;

  PlaceSuggestion.fromPrediction(google.Prediction prediction) {
    this.mainText = prediction.structuredFormatting.mainText;
    this.secondaryText = prediction.structuredFormatting.secondaryText ?? '';
    this.description = prediction.description ?? '';
    this.placeId = prediction.placeId;
  }

  PlaceSuggestion.withLocation(Location location) {
    this.location = location;
  }
}
