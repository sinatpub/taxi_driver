import 'dart:io';
import 'package:com.tara_driver_application/data/models/register_model.dart';
import 'package:com.tara_driver_application/core/api_service/base_api_service.dart';
import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:dio/dio.dart';

class UserRegisterRemoteDataSource {
  final BaseApiService baseApiService = BaseApiService();

  UserRegisterRemoteDataSource();

  Future<RegisterModel> driverRegister({
    required String fullName,
    required String phoneNumber,
    required String vehicalId,
    required String vehicalColor,
    required String deviceToken,
    required String platform,
    required String plateNumber,
    required File cardImage,
    required File profileImage,
    required File driverLicenseImage,
  }) async {
    FormData formData = FormData.fromMap({
      "fullname": fullName.toString(),
      "phone": phoneNumber,
      "type_vehicle_id": vehicalId,
      "color": vehicalColor,
      "plate_number": plateNumber,
      "device_token": deviceToken,
      "platform": platform,
      "card_image": await MultipartFile.fromFile(cardImage.path),
      "profile_image": await MultipartFile.fromFile(profileImage.path),
      "driver_license_image":
          await MultipartFile.fromFile(driverLicenseImage.path),
    });

    return baseApiService.onRequest<RegisterModel>(
      path: "/taxi-driver/register",
      method: "POST",
      headers: {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      },
      onSuccess: (result) {
        tlog("Message after success ${result.data}");
        return RegisterModel.fromJson(result.data);
      },
      bodyParse: formData,
    );
  }
}
