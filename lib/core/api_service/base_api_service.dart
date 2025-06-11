import 'dart:io';
import 'package:tara_driver_application/core/storages/get_storages.dart';
import 'package:tara_driver_application/core/utils/app_constant.dart';
import 'package:dio/dio.dart';
import 'package:tara_driver_application/core/api_service/client/dio_http_client.dart';
import 'package:tara_driver_application/core/api_service/client/http_exception.dart';
import 'package:tara_driver_application/core/utils/errror_message.dart';
import 'package:tara_driver_application/core/utils/pretty_logger.dart';

class BaseApiService {
  late Dio dio;
  BaseApiService({Dio? dio}) {
    if (dio != null) {
      this.dio = dio;
    } else {
      this.dio = BaseHttpClient.dio;
    }
  }

  Future<T> onRequest<T>({
    required String path,
    required String method,
    required T Function(Response) onSuccess,
    Map<String, dynamic>? query,
    Map<String, dynamic> headers = const {},
    dynamic bodyParse = const {},
    bool requiredToken = true,
    String? customToken,
    Dio? customDioClient,
    bool autoRefreshToken = true,
  }) async {
    late Response response;

    // Await token retrieval
    var driverData = await StorageGet.getDriverData();
    String? accessToken = driverData?.data?.token;
    AppConstant.driverToken = accessToken;

    try {
      final httpOption = Options(method: method, headers: {});
      if (requiredToken && accessToken != null) {
        httpOption.headers!['Authorization'] =
            "Bearer ${AppConstant.driverToken}";
      }

      if (customToken != null) {
        httpOption.headers!['Authorization'] = "Bearer $customToken";
      }

      // Prepare FormData for handling files and other data
      FormData formData = FormData();
      if (bodyParse != null && bodyParse is Map<String, dynamic>) {
        for (var entry in bodyParse.entries) {
          // Now this will work as expected
          if (entry.value is File) {
            formData.files.add(MapEntry(
                entry.key,
                await MultipartFile.fromFile(entry.value.path,
                    filename: entry.value.path.split('/').last)));
          } else {
            formData.fields.add(MapEntry(entry.key, entry.value.toString()));
          }
        }
      }

      httpOption.headers!.addAll(headers);
      query ??= {};
      if (customDioClient != null) {
        response = await customDioClient.request(
          path,
          options: httpOption,
          queryParameters: query,
          data: bodyParse,
        );
      } else {
        response = await dio.request(
          path,
          options: httpOption,
          queryParameters: query,
          data: bodyParse,
        );
      }

      if (response.data == null) {
        return onSuccess(response);
      }
      return onSuccess(response);
    } on DioException catch (exception) {
      // await Sentry.captureException(exception, stackTrace: stackTrace);
      throw _onDioError(exception);
    } on ServerResponseException catch (exception) {
      // await Sentry.captureException(exception, stackTrace: stackTrace);
      throw _onServerResponseException(exception, response);
    } catch (exception) {
      // await Sentry.captureException(exception, stackTrace: stackTrace);
      throw _onTypeError(exception);
    }
  }
}

String _onTypeError(dynamic exception) {
  ///Logic or syntax error on some condition
  tlog(
      "Type Error :=> ${exception.toString()}\nStackTrace:  ${exception.stackTrace.toString()}",
      level: LogLevel.error);
  return ErrorMessage.SOMETHING_WRONG;
}

//
DioErrorException _onDioError(DioException exception) {
  _logDioError(exception);
  if (exception.error is SocketException) {
    ///Socket exception mostly from internet connection or host
    return DioErrorException(ErrorMessage.CONNECTION_ERROR);
  } else if (exception.type == DioExceptionType.connectionTimeout) {
    ///Connection timeout due to internet connection or server not responding
    return DioErrorException(ErrorMessage.TIMEOUT_ERROR);
  } else if (exception.type == DioExceptionType.badResponse) {
    ///Error that range from 400-500
    String serverMessage;
    if (exception.response!.data is Map) {
      serverMessage =
          exception.response?.data["message"] ?? ErrorMessage.UNEXPECTED_ERROR;
    } else {
      serverMessage = ErrorMessage.UNEXPECTED_ERROR;
    }
    return DioErrorException(serverMessage,
        code: exception.response!.statusCode);
  }
  throw DioErrorException(ErrorMessage.UNEXPECTED_ERROR);
}

ServerResponseException _onServerResponseException(
    dynamic exception, Response response) {
  tlog(
      "Http Log: Server error :=> ${response.requestOptions.path}:=> $exception");
  //httpLog("Server error :=> ${response.requestOptions.path}:=> $exception");
  return ServerResponseException(exception.toString());
}

void _logDioError(DioException exception) {
  String errorMessage = "Dio error :=> ${exception.requestOptions.path}";
  if (exception.response != null) {
    errorMessage += ", Response: => ${exception.response!.data.toString()}";
  } else {
    errorMessage += ", ${exception.message}";
  }

  tlog("Http Log: Server error :=> $errorMessage");
}

String handleExceptionError(dynamic error, [String path = ""]) {
  tlog("Exception caught [${error.runtimeType}][$path]: ${error.toString()}");
  String errorMessage = ErrorMessage.UNEXPECTED_ERROR;
  //Dio Error
  if (error is DioException) {
    if (error.error is SocketException) {
      errorMessage = ErrorMessage.CONNECTION_ERROR;
    } else if (error.type == DioExceptionType.connectionTimeout) {
      errorMessage = ErrorMessage.TIMEOUT_ERROR;
    } else if (error.type == DioExceptionType.badResponse) {
      tlog("Dio Response error on: ${error.requestOptions.path}");
      if (error.response!.statusCode == 502) {
        errorMessage =
            "${error.response!.statusCode}: ${ErrorMessage.SERVER_ERROR}";
      } else {
        errorMessage =
            "${error.response!.statusCode}: ${ErrorMessage.UNEXPECTED_ERROR}";
      }
    }
    return errorMessage;
    //Json convert error
  } else if (error is TypeError) {
    tlog(error.stackTrace.toString());
    return errorMessage;
    //Error message from server
  } else if (error is ArgumentError) {
    throw errorMessage;
  } else {
    return error.toString();
  }
}
