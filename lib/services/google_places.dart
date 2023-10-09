import 'package:google_maps_webservice/places.dart';
import 'package:packedoo_app_material/constants/pack_constants.dart';
import 'package:packedoo_app_material/models/location.dart' as Packedoo;
import 'package:packedoo_app_material/models/place_suggestion.dart';

GooglePlacesService googlePlacesService = GooglePlacesService();

class GooglePlacesService {
  final places = GoogleMapsPlaces(apiKey: PackConstants.kGoogleApiKey);

  Future<Packedoo.Location> locationDetails(String placeId,
      {String lang = 'en'}) async {
    final response = await places.getDetailsByPlaceId(placeId, language: lang);

    return response.isOkay
        ? Packedoo.Location.fromPlaceDetails(response.result)
        : null;
  }

  Future<List<PlaceSuggestion>> suggestions(String input,
      {String lang = 'en'}) async {
    PlacesAutocompleteResponse response = await places.autocomplete(
      input,
      language: lang,
    );

    return response.hasNoResults
        ? []
        : List<PlaceSuggestion>.from(response.predictions
            .map((prediction) => PlaceSuggestion.fromPrediction(prediction)));
  }
}
