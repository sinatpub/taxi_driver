import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';

class BaseHttpClient {
  static late final Dio dio;

  static void init() {
    final BaseOptions options = BaseOptions(
      baseUrl: AppConstant.baseUrlApi,
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
    );

    dio = Dio()
      ..options = options
      ..interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: false,
          error: true,
          request: true));
  }
}

////
// class V2ApiClient {
//   static late final Dio dio;
//   static void init() {
//     final BaseOptions options = BaseOptions(
//       baseUrl: AppConfig.BASE_URL,
//       connectTimeout: const Duration(minutes: 1),
//       receiveTimeout: const Duration(minutes: 1),
//     );
//
//     dio = Dio()
//       ..options = options
//       ..interceptors.add(PrettyDioLogger(
//         requestHeader: true,
//         requestBody: true,
//         responseBody: true,
//         responseHeader: false,
//         compact: false,
//         error: true,
//       ));
//   }
// }

const JsonDecoder decoder = JsonDecoder();
const JsonEncoder encoder = JsonEncoder.withIndent('  ');
