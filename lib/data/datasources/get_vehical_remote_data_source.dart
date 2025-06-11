import 'package:tara_driver_application/core/api_service/base_api_service.dart';
import 'package:tara_driver_application/core/utils/pretty_logger.dart';
import 'package:tara_driver_application/data/models/vehical_model.dart';

class GetVehicalRemoteDataSource {
  Future<VehicalTypeEntities> getAllVehicalApi() async {
    return BaseApiService().onRequest(
      path: "/taxi/get-type-vehicle",
      method: "GET",
      onSuccess: (result) {
        tlog("Message after success: ${result.data}");
        return VehicalTypeEntities.fromJson(result.data);
      },
    );
  }
}
