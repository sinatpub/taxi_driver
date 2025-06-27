import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:tara_driver_application/app/alert_widget.dart';
import 'package:tara_driver_application/core/resources/asset_resource.dart';
import 'package:tara_driver_application/core/utils/pretty_logger.dart';
import 'package:tara_driver_application/presentation/blocs/get_current_driver_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tara_driver_application/core/theme/colors.dart';
import 'package:tara_driver_application/core/theme/text_styles.dart';
import 'package:tara_driver_application/presentation/blocs/get_profile_bloc.dart';
import 'package:tara_driver_application/presentation/screens/home_screen/widgets/switch_online_widget.dart';
import 'package:tara_driver_application/presentation/screens/home_screen/home_screen.dart';
import 'package:tara_driver_application/presentation/screens/history_booking/riding_history_screen.dart';
import 'package:tara_driver_application/presentation/widgets/simmer_widget.dart';
import 'package:tara_driver_application/presentation/widgets/t_image_widget.dart';
import 'package:tara_driver_application/presentation/widgets/widget_change_laguage.dart';

class DrawerScreen extends StatefulWidget {
  DrawerScreen({super.key,});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool isApproved = true;

  
  bool connection = true;
  StreamSubscription? sub;
  int isActiveIndex = 0;
  @override
  void initState() {
    setState(() {
      
    });
    //=============Check internet====================
      sub = InternetConnection().onStatusChange.listen((event) {
        switch (event) {
          case InternetStatus.connected:
            setState(() {
              connection = true;
            });
            break;
          case InternetStatus.disconnected:
            setState(() {
              connection = false;
            });
            break;
          default:
            setState(() {
              connection = false;
            });
            break;
        }
      });
      //=============Eend Check internet====================
    // BlocProvider.of<CurrentDriverInfoBloc>(context).add(GetCurrentInfoEvent());
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translate = context.locale.toString();
    return Scaffold(
      backgroundColor: AppColors.light1,
        appBar: AppBar(
          foregroundColor:AppColors.dark1,
          backgroundColor: AppColors.light4,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                   isActiveIndex == 0?"WELCOME_TO_TARA".tr():"RIDING_HISTORY".tr(),style: ThemeConstands.font20SemiBold.copyWith(color: AppColors.dark1),
                   textAlign: TextAlign.center,
                   overflow: TextOverflow.ellipsis,
                ),
              ),
              isActiveIndex ==0? SwitchOnlineWidget():Container(width: 55,),
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: AppColors.main,
                  border: Border.all(color: Colors.transparent)
                ),
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if(state is ProfileLoading){
                      return const ShimmerProfile();
                    }
                    else if(state is ProfileLoaded){
                      var data = state.profileData.data;
                      return Container(
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Profile Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: TImageWidget(
                                image:
                                    NetworkImage(data!.profileImage.toString()),
                                width: 80,
                                height: 80,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Info Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data.name.toString(),
                                    style: ThemeConstands.font22SemiBold
                                        .copyWith(color: AppColors.light4),
                                  ),
                                  Text(
                                    data.phone.toString(),
                                    style: ThemeConstands.font16Regular
                                        .copyWith(color: AppColors.light4),
                                  ),
                                  Row(
                                    children: [
                                      RatingBarIndicator(
                                        rating: 3.5,
                                        itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                                        itemCount: 5,
                                        itemSize: 18.0,
                                        direction: Axis.horizontal,
                                      ),
                                      Text(
                                        "3.5",
                                        style: ThemeConstands.font14Regular
                                            .copyWith(color: AppColors.light4),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    else{
                      return const ShimmerProfile();
                    }
                  },
                ),
              ),
              // Body List
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        selectedColor: AppColors.main,
                        leading: SvgPicture.asset(ImageAssets.home_outline,color: AppColors.main,),
                        title: Text("HOME".tr(),style: ThemeConstands.font20Regular,),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            isActiveIndex = 0;
                          });
                          // Handle navigation
                        },
                      ),
                      ListTile(
                        selectedColor: AppColors.main,
                        leading: SvgPicture.asset(ImageAssets.book_outline,color: AppColors.main,),
                        title: Text("HISTORY".tr(),style: ThemeConstands.font20Regular,),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            isActiveIndex = 1;
                          });
                          // Handle navigation
                        },
                      ),
                      ListTile(
                        selectedColor: AppColors.main,
                        leading: SvgPicture.asset(ImageAssets.icon_contact_setting),
                        title: Text("TERMCONDITION".tr(),style: ThemeConstands.font20Regular,),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                          });
                          // Handle navigation
                        },
                      ),
                      ListTile(
                        selectedColor: AppColors.main,
                        leading: Icon(Icons.contact_phone_outlined,size: 22,color: AppColors.main,),
                        title: Text("CONTACTUS".tr(),style: ThemeConstands.font20Regular,),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                          });
                          // Handle navigation
                        },
                      ),
                      ListTile(
                        selectedColor: AppColors.main,
                        leading: SvgPicture.asset(ImageAssets.icon_setting_setting,color: AppColors.main,),
                        title: Text("SETTING".tr(),style: ThemeConstands.font20Regular,),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                          });
                          // Handle navigation
                        },
                      ),
                      ListTile(
                        selectedColor: AppColors.main,
                        leading: translate == "km"
                        ? SvgPicture.asset(
                            ImageAssets.flag_km,
                            width: 30,
                          )
                        : Image.asset(
                            ImageAssets.flag_en,
                            width: 30,
                        ),
                        title: Text("CHOOSE_LANGUADE".tr(),style: ThemeConstands.font20Regular,),
                        onTap: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)),
                            ),
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter stateSetter) {
                                return ChangeLanguage();
                              });
                            });
                          // Handle navigation
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16,top: 28),
                        decoration: const BoxDecoration(
                          color: AppColors.light4,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFEDEBEB),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: MaterialButton(
                          height: 50,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          elevation: 0,
                          onPressed: () async {
                            AlertWidget().logout(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(ImageAssets.icon_logout,
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text("LOGOUT".tr(),
                                style: ThemeConstands.font16Regular
                                    .copyWith(color: AppColors.dark1),
                                textAlign: TextAlign.left,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
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
                  child:isActiveIndex == 1? const RidingHistoryScreen()
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
        
    );
  }
}
