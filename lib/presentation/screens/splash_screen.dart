import 'dart:async';
import 'package:com.tara_driver_application/core/storages/get_storages.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';
import 'package:com.tara_driver_application/presentation/screens/login_page.dart';
import 'package:com.tara_driver_application/presentation/screens/nav_screen.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
import 'package:flutter/material.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void checkDriverToken(BuildContext context) async {
    var driverData = await StorageGet.getDriverData();
    if (driverData != null) {
      // Check Driver Status 
      Taxi.shared.checkDriverAvailability();
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

    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              child: Image.asset("/Users/holy/Desktop/taxi_driver/assets/icon/png/logo_app.png"),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("TARA DRIVER", style: AppTextStyles.heading),
          ],
        ),
      ),
    );
  }
}
