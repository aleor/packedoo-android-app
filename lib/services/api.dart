import 'package:http/http.dart' as http;
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';

final ApiService apiService = ApiService();

class ApiService {
  // final String _endpoint =
  //     'https://europe-west2-packedoo-dev.cloudfunctions.net';
  final String _endpoint =
      'https://europe-west2-packedoo-prod.cloudfunctions.net';
  final _authService = authService;

  Future<bool> acceptDeal(String dealId) async {
    GoogleAnalytics().dealAccept();

    final token = await _authService.getFirebaseIdToken();

    final response = await http
        .post('$_endpoint/deals/accept/$dealId', headers: {'token': token});

    return response.statusCode == 200;
  }

  Future<bool> declineDeal(String dealId) async {
    GoogleAnalytics().dealDecline();

    final token = await _authService.getFirebaseIdToken();

    final response = await http
        .post('$_endpoint/deals/decline/$dealId', headers: {'token': token});

    return response.statusCode == 200;
  }

  Future<bool> cancelDeal(String dealId, String reason) async {
    GoogleAnalytics().dealCancel();

    final token = await _authService.getFirebaseIdToken();

    final response = await http.post('$_endpoint/deals/cancel/$dealId',
        headers: {'token': token}, body: {'reason': reason});

    return response.statusCode == 200;
  }

  Future<bool> collectDeal(String dealId) async {
    GoogleAnalytics().dealCollect();

    final token = await _authService.getFirebaseIdToken();

    final response = await http
        .post('$_endpoint/deals/collect/$dealId', headers: {'token': token});

    return response.statusCode == 200;
  }

  Future<int> deliverDeal(String dealId, int code) async {
    GoogleAnalytics().dealDeliver();

    final token = await _authService.getFirebaseIdToken();

    final response = await http.post(
      '$_endpoint/deals/deliver/$dealId',
      headers: {'token': token},
      body: {'code': code.toString()},
    );

    return response.statusCode;
  }

  Future<bool> confirmDelivery(String dealId) async {
    final token = await _authService.getFirebaseIdToken();

    final response = await http
        .post('$_endpoint/deals/confirm/$dealId', headers: {'token': token});

    return response.statusCode == 200;
  }

  Future<String> getPhone(String dealId) async {
    final token = await _authService.getFirebaseIdToken();

    final response = await http
        .post('$_endpoint/deals/phone/$dealId', headers: {'token': token});

    return response.body;
  }
}
