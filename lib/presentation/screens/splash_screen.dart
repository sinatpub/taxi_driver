import 'dart:async';
import 'package:com.tara_driver_application/core/storages/get_storages.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';
import 'package:com.tara_driver_application/presentation/screens/login_page.dart';
import 'package:com.tara_driver_application/presentation/screens/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void checkDriverToken(BuildContext context) async {
    var driverData = await StorageGet.getDriverData();
    if (driverData != null) {
      AppConstant.driverToken = driverData.data?.token;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NavScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      checkDriverToken(context);
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
            ),
            SizedBox(
              height: 10,
            ),
            Text("TARA DRIVER", style: AppTextStyles.heading),
          ],
        ),
      ),
    );
  }
}
