import 'package:cloud_functions/cloud_functions.dart';
import 'package:packedoo_app_material/models/long_lat.dart';
import 'package:packedoo_app_material/models/price.dart';
import 'package:packedoo_app_material/services/callable.dart';

CostService costService = CostService();

class CostService {
  Future<Price> calculate(
      {LongLat originCoordinates,
      LongLat destinationCoordinates,
      int size}) async {
    final HttpsCallable costCallable = Callable.instance.getHttpsCallable(
      functionName: 'cost_v2',
    );

    final response = await costCallable.call(<String, dynamic>{
      'origin': {
        'coordinate': {
          'lat': originCoordinates.lat,
          'lng': originCoordinates.long
        }
      },
      'destination': {
        'coordinate': {
          'lat': destinationCoordinates.lat,
          'lng': destinationCoordinates.long
        }
      },
      'size': size
    });

    return Price.fromMap(response.data);
  }
}
