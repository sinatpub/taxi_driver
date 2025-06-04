import 'dart:convert';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/presentation/screens/home_screen/bloc/home_bloc.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi_location.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class SwitchOnlineWidget extends StatelessWidget {
  const SwitchOnlineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var homeBloc = BlocProvider.of<HomeBloc>(context);

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return FlutterSwitch(
          activeTextColor: AppColors.light4,
          inactiveTextColor: AppColors.error,
          activeColor: AppColors.success,
          inactiveColor: AppColors.light1,
          activeText: "ONLINE".tr(),
          inactiveText: "OFFLINE".tr(),
          value: homeBloc.isOnline,
          valueFontSize: 14.0,
          width: 110,
          borderRadius: 15,
          height: 30,
          toggleSize: 35,
          padding: 3,
          showOnOff: true,
          onToggle: (val) async {
            homeBloc.add(ToggleOnOffDriverEvent(isTurnOn: val == true ? 1 : 0));
          },
        );
      },
    );
  }
}
