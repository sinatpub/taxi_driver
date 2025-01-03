import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/presentation/blocs/get_current_driver_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  bool isApproved = true;

  @override
  void initState() {
    BlocProvider.of<CurrentDriverInfoBloc>(context).add(GetCurrentInfoEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<CurrentDriverInfoBloc, CurrentDriverInfoState>(
          listener: (context, state) {
            if (state is CurrentDriverLoading) {
              tlog("Current Driver Loading");
            } else if (state is CurrentDriverInfoLoaded) {
              var dataDriver = state.currentDriverInfoModel.data;
              tlog("Current Driver Loaded");
              setState(() {
                isApproved = true;
              });
              if(dataDriver != null){
                
              }
            } else {
              setState(() {
                isApproved = false;
              });
              tlog("Current Driver Fail");
            }
          },
          child: Stack(
            children: [
              SafeArea(
                  bottom: false,
                  child: selectedIndex == 2
                      ? const ProfileScreen()
                      : selectedIndex == 1
                          ? const RidingHistoryScreen()
                          : const HomeScreen()),
              isApproved == false
                  ? Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: Container(
                        color: Colors.white.withOpacity(.1),
                      ))
                  : const SizedBox(),
              isApproved == false
                  ? Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 250,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            SvgPicture.asset(
                                "assets/icon/svg/waiting_approve.svg"),
                            const Text(
                              "Waiting Approval From Admin",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                            const Text(
                              "Your account is pending admin approval. You’ll be notified once it's ready to use. Thank you for your patience!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        bottomNavigationBar: isApproved == false
            ? null
            : Container(
                decoration: const BoxDecoration(boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 100.0,
                    offset: Offset(10.0, 55.75),
                  ),
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
