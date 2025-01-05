import 'package:com.tara_driver_application/core/api_service/base_api_service.dart';
import 'package:com.tara_driver_application/data/models/driver_location_model.dart';
import 'package:dio/dio.dart';

class UpdateDriverLocation {
  Future<UpdateDriverLocationModel> updateDriverLocationApi(
      {double? lat, double? log}) async {
    FormData formData = FormData.fromMap({
      "latitude": lat,
      "longitude": log,
    });

    return BaseApiService().onRequest<UpdateDriverLocationModel>(
      path: "/taxi-driver/update-driver-location",
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      // customToken: "28|MTbCFQGmG4orNpm7GA0lVKPR4gopEjMHO8Zrq4iY",
      onSuccess: (result) {
        print("Update location again $result");
        return UpdateDriverLocationModel?.fromJson(result.data);
      },
      bodyParse: formData,
    );
  }
}
