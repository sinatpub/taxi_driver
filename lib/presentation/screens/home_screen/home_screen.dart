import 'dart:async';
import 'package:com.tara_driver_application/core/storages/get_storages.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';
import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/data/models/register_model.dart';
import 'package:com.tara_driver_application/presentation/blocs/get_current_driver_info_bloc.dart';
import 'package:com.tara_driver_application/presentation/screens/booking/booking/booking_screen.dart';
import 'package:com.tara_driver_application/presentation/screens/calculate_fee_screen.dart';
import 'package:com.tara_driver_application/presentation/screens/home_screen/bloc/home_bloc.dart';
import 'package:com.tara_driver_application/presentation/screens/home_screen/widgets/switch_online_widget.dart';
import 'package:com.tara_driver_application/services/location_bloc/location_bloc.dart';
import 'package:com.tara_driver_application/services/location_bloc/location_event.dart';
import 'package:com.tara_driver_application/services/location_bloc/location_state.dart';
import 'package:com.tara_driver_application/taxi_single_ton/init_socket.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // * Socket Class
  DriverSocketService driverSocket = DriverSocketService();
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      registerSocket();
    });

    // bloc
    BlocProvider.of<HomeBloc>(context).add(CheckDriverStatusEvent());
    BlocProvider.of<LocationBloc>(context).add(RequestLocationPermission());
  }

  // * Register Socket
  void registerSocket() async {
    RegisterModel? driverData = await StorageGet.getDriverData();
    if (driverData?.data?.driver?.id != null) {
      driverSocket.connectToSocket(
        AppConstant.socketBasedUrl,
        "${driverData?.data?.driver?.id}",
        "Driver",
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentDriverInfoBloc, CurrentDriverInfoState>(
      listener: (blocContext, state) {
        handleStateChanges(state);
      },
      builder: (blocContext, state) {
        return Column(
          children: [
            buildHeader(),
            Expanded(child: buildGoogleMap()),
            if (state is CurrentDriverLoading) const SizedBox(),
          ],
        );
      },
    );
  }

  void handleStateChanges(CurrentDriverInfoState state) {
    if (state is CurrentDriverLoading) {
      tlog("Current Driver Loading");
    } else if (state is CurrentDriverInfoLoaded) {
      tlog("Current Driver Loaded");
      navigateBasedOnDriverStatus(state.currentDriverInfoModel.data);
    } else {
      tlog("Current Driver Fail");
    }
  }

  void navigateBasedOnDriverStatus(dataDriver) {
    if (dataDriver != null) {
      if (dataDriver.status == 6) {
        navigateToCalculateFeeScreen(dataDriver);
      } else if (dataDriver.status != null) {
        navigateToBookingScreen(dataDriver);
      }
    }
  }

  void navigateToCalculateFeeScreen(dataDriver) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CalculateFeeScreen(
          dataDriverInfo: dataDriver,
          routFrom: "FromHome",
          startAddress: dataDriver.startAddress.toString(),
          endAddress: dataDriver.endAddress.toString(),
        ),
      ),
    );
  }

  void navigateToBookingScreen(dataDriver) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          namePassanger: dataDriver.passenger!.name.toString(),
          phonePassanger: dataDriver.passenger!.phone.toString(),
          imagePassanger: dataDriver.passenger!.profileImage.toString(),
          timeOut: 30,
          processStepBook: getProcessStepBook(dataDriver.status!),
          bookingCode: dataDriver.bookingCode.toString(),
          bookingId: dataDriver.id.toString(),
          latPassenger: double.parse(dataDriver.passenger!.lastLocation!.latitude.toString()),
          lngPassenger: double.parse(dataDriver.passenger!.lastLocation!.longitude.toString()),
          latDriver: double.parse(dataDriver.driver!.lastLocation!.latitude.toString()),
          lngDriver: double.parse(dataDriver.driver!.lastLocation!.longitude.toString()),
          passengerId: dataDriver.passenger!.id.toString(),
          desLatPassenger: null,
          desLngPassenger: null,
        ),
      ),
    );
  }

  int getProcessStepBook(int status) {
    switch (status) {
      case 8:
        return 3;
      case 3:
        return 4;
      default:
        return 2;
    }
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "WELCOME_TO_TARA".tr(),
            style: ThemeConstands.font18SemiBold.copyWith(color: AppColors.dark1),
          ),
          const SwitchOnlineWidget(),
        ],
      ),
    );
  }

 Widget buildGoogleMap() {
  return BlocBuilder<LocationBloc, LocationState>(
    builder: (context, state) {
      if (state is LocationLoadInProgress) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is LocationLoadSuccess) {
        return GoogleMap(
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
          mapType: MapType.normal,
          myLocationEnabled: true,
          compassEnabled: true,
          trafficEnabled: true,
          initialCameraPosition: CameraPosition(
            target: state.currentLocation,
            zoom: 17.0,
          ),
          markers: context.read<LocationBloc>().setMarker ?? {},
          onMapCreated: (GoogleMapController controller) {
            context.read<LocationBloc>().mapController = controller;
            if (!isCameraInitialized) {
              controller.animateCamera(
                CameraUpdate.newLatLng(state.currentLocation),
              );
              isCameraInitialized = true;
            }
          },
        );
      } else if (state is LocationPermissionDenied) {
        return const Center(child: Text('Location permission denied'));
      } else if (state is LocationLoadFailure) {
        return Center(child: Text('Failed to load location: ${state.error}'));
      } else {
        return const Center(child: Text('Something went wrong'));
      }
    },
  );
}

}

Future<BitmapDescriptor> loadCustomMarker({required String imagePath}) async {
  BitmapDescriptor convertMarkerIcon = await BitmapDescriptor.asset(
    const ImageConfiguration(),
    imagePath,
  );
  return convertMarkerIcon;
}
