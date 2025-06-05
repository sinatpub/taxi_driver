import 'package:com.tara_driver_application/app/root_main.dart';
import 'package:com.tara_driver_application/app/service.dart';
import 'package:com.tara_driver_application/presentation/widgets/custom_animated_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:com.tara_driver_application/core/api_service/client/dio_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';




void main() async {
  BaseHttpClient.init();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];
  // * initial service
  initialService();
  // * config easy loading
  configLoading();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('km'), Locale('en')],
      path: 'assets/translations',
      startLocale: const Locale('en'),
      child: const Root(),
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = true
    ..customAnimation = CustomAnimation();
}
