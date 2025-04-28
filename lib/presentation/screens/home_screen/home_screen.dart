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
import 'package:com.tara_driver_application/taxi_single_ton/init_socket.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi_location.dart';
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
  double driverCurrentLat = 0.0;
  double driverCurrentLng = 0.0;
  GoogleMapController? mapController;

  // * Socket Class
  DriverSocketService driverSocket = DriverSocketService();
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    // Taxi.shared.updateDriverLocation();
    // Taxi.shared.setupBackgroundLocationTracking();
    initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      registerSocket();
    });

    // bloc
    BlocProvider.of<HomeBloc>(context).add(CheckDriverStatusEvent());
  }

  void initialize() async {
    // _updateMarkerPosition();
    if (!isCameraInitialized) {
      mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(driverCurrentLat, driverCurrentLng),
        ),
      );
      isCameraInitialized = true; // Camera is now initialized
      TaxiLocation.shared.updateCurrentLocationDriver();
    }
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

  // void _updateMarkerPosition() async {
  //   setState(() {
  //     _markers.removeWhere(
  //       (marker) => marker.markerId == const MarkerId("driverMarker"),
  //     );
  //     // _markers.add(Taxi.shared.driverMarker);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentDriverInfoBloc, CurrentDriverInfoState>(
      listener: (blocContext, state) {
        if (state is CurrentDriverLoading) {
          tlog("Current Driver Loading");
        } else if (state is CurrentDriverInfoLoaded) {
          var dataDriver = state.currentDriverInfoModel.data;
          tlog("Current Driver Loaded");
          if (dataDriver != null) {
            if (dataDriver.status == 6) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CalculateFeeScreen(
                          dataDriverInfo: dataDriver,
                          routFrom: "FromHome",
                          startAddress: dataDriver.startAddress.toString(),
                          endAddress: dataDriver.endAddress.toString())));
            } else if (dataDriver.status == null) {
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(
                    namePassanger: dataDriver.passenger!.name.toString(),
                    phonePassanger: dataDriver.passenger!.phone.toString(),
                    imagePassanger:
                        dataDriver.passenger!.profileImage.toString(),
                    timeOut: 30,
                    processStepBook: dataDriver.status! == 8
                        ? 3
                        : dataDriver.status! == 3
                            ? 4
                            : 2,
                    bookingCode: dataDriver.bookingCode.toString(),
                    bookingId: dataDriver.id.toString(),
                    latPassenger: double.parse(dataDriver
                        .passenger!.lastLocation!.latitude
                        .toString()),
                    lngPassenger: double.parse(dataDriver
                        .passenger!.lastLocation!.longitude
                        .toString()),
                    latDriver: double.parse(
                        dataDriver.driver!.lastLocation!.latitude.toString()),
                    lngDriver: double.parse(
                        dataDriver.driver!.lastLocation!.longitude.toString()),
                    passengerId: dataDriver.passenger!.id.toString(),
                  ),
                ),
              );
            }
          }
        } else {
          tlog("Current Driver Fail");
        }
      },
      builder: (blocContext, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "WELCOME_TO_TARA".tr(),
                    style: ThemeConstands.font18SemiBold
                        .copyWith(color: AppColors.dark1),
                  ),
                  const SwitchOnlineWidget(),
                ],
              ),
            ),
            Expanded(child: buildGoogleMap()),
            if (state is CurrentDriverLoading) const SizedBox(),
          ],
        );
      },
    );
  }

  Widget buildGoogleMap() {
    return TaxiLocation.shared.currentLocation.latitude == 0.0 ||
            TaxiLocation.shared.currentLocation.longitude == 0.0
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMap(
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
              target: LatLng(
                TaxiLocation.shared.currentLocation.latitude,
                TaxiLocation.shared.currentLocation.longitude,
              ),
              zoom: 17.0,
            ),
            markers: TaxiLocation.shared.setMarker ?? {},
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              if (!isCameraInitialized) {
                controller.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(
                      TaxiLocation.shared.currentLocation.latitude,
                      TaxiLocation.shared.currentLocation.longitude,
                    ),
                  ),
                );
                isCameraInitialized = true;
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
