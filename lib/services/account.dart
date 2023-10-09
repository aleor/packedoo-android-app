import 'package:cloud_functions/cloud_functions.dart';
import 'package:packedoo_app_material/services/callable.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';

AccountService accountService = AccountService();

class AccountService {
  Future requestPhoneConfirmation() async {
    GoogleAnalytics().accountRequestPhoneConfirmation();
    final HttpsCallable callable = Callable.instance.getHttpsCallable(
      functionName: 'requestPhoneConfirmation',
    );

    final response = await callable.call();

    return response.data;
  }

  Future<bool> confirmPhone(int code) async {
    final HttpsCallable callable = Callable.instance.getHttpsCallable(
      functionName: 'confirmPhone',
    );

    await callable.call({'code': code});

    return true;
  }
}
