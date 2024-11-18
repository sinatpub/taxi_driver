import 'package:com.tara_driver_application/core/api_service/base_api_service.dart';
import 'package:com.tara_driver_application/data/models/phone_model.dart';

class PhoneNumerRemoteDataSource {
  Future<PhoneNumberModel> postPhoneNumberApi(
      {required String phoneNumer}) async {
    return BaseApiService().onRequest(
        path: "/taxi-driver/login-phone",
        method: "POST",
        requiredToken: false,
        onSuccess: (result) {
          return PhoneNumberModel.fromJson(result.data);
        },
        bodyParse: {"phone": phoneNumer});
  }
}
