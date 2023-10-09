import 'package:cloud_functions/cloud_functions.dart';

class Callable {
  static const region = 'europe-west2';

  static get instance => CloudFunctions(region: region);
}
