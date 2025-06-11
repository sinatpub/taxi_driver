import 'package:tara_driver_application/core/theme/app_theme.dart';
import 'package:tara_driver_application/core/utils/app_constant.dart';
import 'package:tara_driver_application/presentation/blocs/multi_bloc.dart';
import 'package:tara_driver_application/presentation/screens/splash_screen.dart';
import 'package:tara_driver_application/services/navigation_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: const [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: MultiBlocProvider(
        providers: listBlocProvider,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          navigatorKey: NavigationService().navigatorKey,
          locale: context.locale,
          title: AppConstant.titleApp,
          theme: AppTheme.lightTheme,
          home: const SplashScreen(),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}
