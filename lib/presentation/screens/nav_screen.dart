import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:com.tara_driver_application/core/resources/asset_resource.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';
import 'package:com.tara_driver_application/presentation/screens/profile_screen.dart';
import 'package:com.tara_driver_application/presentation/screens/home_screen/home_screen.dart';
import 'package:com.tara_driver_application/presentation/screens/riding_history_screen.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int selectedIndex = 0;

  // Future<bool> requestLocationPermission() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   LocationPermission permission = await Geolocator.checkPermission();

  //   if (!serviceEnabled) {
  //     showLocationServiceDisabledSnackBar(context);
  //     return false;
  //   }
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       debugPrint("Permission Denied");
  //       return false;
  //     }
  //   }
  //   debugPrint("permission is allowed");
  //   return true;
  // }

  // void determinePosition() async {
  //   bool granted = await requestLocationPermission();
  //   if(granted == true){
  //     try {
  //       setState(() async{
  //           await Geolocator.getCurrentPosition().then((value) {

  //           });
  //         // });
  //       });
  //     } catch (e) {
  //       if (e is TimeoutException) {
  //         debugPrint('Location request timed out.');
  //       } else {
  //         debugPrint('Error fetching location: $e');
  //       }
  //     }
  //   }else{
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission denied.')));
  //   }
  // }

  // void showLocationServiceDisabledSnackBar(context) {
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //     content: Text('Please enable location services.'),
  //   ));
  // }

  // Future checkLogin() async {
  //   Future.delayed(const Duration(milliseconds: 1500), () async{
  //       setState(() {
  //         determinePosition();
  //       });
  //   });
  // }

  @override
  void initState() {
    setState(() {
      // requestLocationPermission();
      //  checkLogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            bottom: false,
            child: selectedIndex == 2
                ? const ProfileScreen()
                : selectedIndex == 1
                    ? const RidingHistoryScreen()
                    : const HomeScreen()),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey,
                blurRadius: 100.0,
                offset: Offset(10.0, 55.75))
          ], color: Colors.white),
          height: 92,
          child: Row(
            children: [
              itemNav(() {
                setState(() {
                  selectedIndex = 0;
                });
              },
                  "Home",
                  selectedIndex != 0
                      ? ImageAssets.home_outline
                      : ImageAssets.home,
                  0),
              itemNav(() {
                setState(() {
                  selectedIndex = 1;
                });
              },
                  "History",
                  selectedIndex != 1
                      ? ImageAssets.book_outline
                      : ImageAssets.book,
                  1),
              itemNav(() {
                setState(() {
                  selectedIndex = 2;
                });
              },
                  "Profile",
                  selectedIndex != 2
                      ? ImageAssets.profile
                      : ImageAssets.profile_fill,
                  2),
            ],
          ),
        ));
  }

  Widget itemNav(
      VoidCallback onTap, String title, String icon, int currentActive) {
    return Expanded(
      child: MaterialButton(
        padding: const EdgeInsets.all(0),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(icon,
                color: currentActive == selectedIndex
                    ? AppColors.error
                    : AppColors.dark1),
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                  color: currentActive == selectedIndex
                      ? AppColors.error
                      : AppColors.dark1),
            ),
            const SizedBox(
              height: 18,
            )
          ],
        ),
      ),
    );
  }
}
