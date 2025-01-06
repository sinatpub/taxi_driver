import 'package:com.tara_driver_application/presentation/blocs/multi_bloc.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:com.tara_driver_application/core/api_service/client/dio_http_client.dart';
import 'package:com.tara_driver_application/core/theme/app_theme.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';
import 'package:com.tara_driver_application/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:com.tara_driver_application/presentation/screens/splash_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  BaseHttpClient.init();
  di.init();
  WidgetsFlutterBinding.ensureInitialized();
  Taxi.shared.initLocationNotification();
  EasyLocalization.logger.enableBuildModes = [];
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('km'), Locale('en')],
      path: 'assets/translations',
      startLocale: const Locale('km'),
      child: const Root(),
    ),
  );
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: listBlocProvider,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: AppConstant.titleApp,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
