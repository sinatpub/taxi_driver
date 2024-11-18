import 'package:com.tara_driver_application/core/api_service/base_api_service.dart';
import 'package:com.tara_driver_application/data/models/confirm_booking_model.dart';
import 'package:dio/dio.dart';

class BookingApi {
  // conform booking service
  Future<ConfirmBookingModel> confirmBookingApi({required int rideId}) async {
    FormData formData = FormData.fromMap({
      "ride_id": rideId,
    });
    return BaseApiService().onRequest<ConfirmBookingModel>(
      path: "/taxi-driver/confirm-drive-request",
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      bodyParse: formData,
      onSuccess: (result) {
        return ConfirmBookingModel?.fromJson(result.data);
      },
    );
  }

// start driver service
  Future<ConfirmBookingModel> startDriverApi({required int rideId}) async {
    FormData formData = FormData.fromMap({
      "ride_id": rideId,
    });
    return BaseApiService().onRequest<ConfirmBookingModel>(
      path: "/taxi-driver/start-drive",
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      bodyParse: formData,
      onSuccess: (result) {
        return ConfirmBookingModel?.fromJson(result.data);
      },
    );
  }

  Future<bool> cancelBookingApi({required int rideId}) async {
    FormData formData = FormData.fromMap({
      "ride_id": rideId,
    });
    return BaseApiService().onRequest<bool>(
      path: "/taxi-driver/cancel-drive",
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      bodyParse: formData,
      onSuccess: (result) {
        return true;
      },
    );
  }

  ///taxi-driver/complete-drive
  ///
  Future<bool> completeDriveApi({
    required int rideId,
    required double endLatitude,
    required double endLongitude,
    required String endAddress,
    required double distance,
  }) async {
    FormData formData = FormData.fromMap({
      "ride_id": rideId,
      "end_latitude": endLatitude,
      "end_longitude": endLongitude,
      "end_address": endAddress,
      "distance": distance,
    });
    return BaseApiService().onRequest<bool>(
      path: "/taxi-driver/complete-drive",
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      bodyParse: formData,
      onSuccess: (result) {
        return true;
      },
    );
  }
}
