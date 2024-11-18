import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:com.tara_driver_application/core/resources/asset_resource.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  var option = [
    "Tuk Tuk",
    "Classic Car",
    "SUV Car",
    "Mini Van",
  ];

  var settingAction = [
    Item(icon: ImageAssets.icon_contact_setting, title: "Contact to Admin"),
    Item(icon: ImageAssets.icon_setting_setting, title: "Setting 02"),
    Item(icon: ImageAssets.icon_logout, title: "Logout"),
  ];

  int activeOption = 0;

  bool switchButton = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hello Kosal",style: ThemeConstands.font18SemiBold.copyWith(color:AppColors.dark1),),
                Container(
                  child: FlutterSwitch(
                    activeTextColor: AppColors.light1,
                    inactiveTextColor: AppColors.error,
                    activeColor: AppColors.error,
                    inactiveColor: AppColors.light1,
                    activeText: "Online",
                    inactiveText: "Offline".tr(),
                    value: switchButton,
                    valueFontSize: 16.0,
                    width: 105,
                    borderRadius: 15,
                    height: 30,
                    toggleSize: 35,
                    padding:3,
                    showOnOff: true,
                    onToggle: (val) {
                      setState(() {
                        switchButton = !switchButton;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 1,color: AppColors.light1,),
          Container(height: 50,),
          const Divider(height: 1,color: AppColors.light1,),
          Expanded(
            child: Container(),
          )
        ],
      ),
    );
  }
}
class Item {
    String icon;
    String title;
  Item({required this.icon,required this.title});
}