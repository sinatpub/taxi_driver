import 'package:com.tara_driver_application/core/api_service/base_api_service.dart';
import 'package:com.tara_driver_application/data/models/profile_model.dart';

class GetProfileDriver {
  Future<ProfileModel> getDriverProfileApi() async {
    return BaseApiService().onRequest<ProfileModel>(
        path: "/taxi-driver/get-profile",
        method: "GET",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        onSuccess: (result) {
          return ProfileModel?.fromJson(result.data);
        });
  }
}
