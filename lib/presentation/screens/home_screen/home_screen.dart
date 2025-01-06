import 'dart:async';
import 'package:com.tara_driver_application/core/storages/get_storages.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';
import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/data/datasources/set_status_api.dart';
import 'package:com.tara_driver_application/data/models/register_model.dart';
import 'package:com.tara_driver_application/presentation/blocs/get_current_driver_info_bloc.dart';
import 'package:com.tara_driver_application/presentation/screens/booking/booking/booking_screen.dart';
import 'package:com.tara_driver_application/presentation/screens/calculate_fee_screen.dart';
import 'package:com.tara_driver_application/taxi_single_ton/init_socket.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';
import 'package:com.tara_driver_application/presentation/widgets/fbtn_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool switchButton = true;
  final Set<Marker> _markers = {};
  double driverCurrentLat = 0.0;
  double driverCurrentLng = 0.0;
  GoogleMapController? mapController;
  final DriverSocketService driverSocketService = DriverSocketService();
  SetDriverStatusApi statusApi = SetDriverStatusApi();

  // * Socket Class
  DriverSocketService driverSocket = DriverSocketService();
  bool isCameraInitialized = false;

  void fetchLocation() async {
    Position? position = await Taxi.shared.checkCurrentLocation();
    if (position != null) {
      setState(() {
        driverCurrentLat = position.latitude;
        driverCurrentLng = position.longitude;
      });
      debugPrint(
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}");
    } else {
      debugPrint("Failed to get location.");
    }
  }

  @override
  void initState() {
    // Taxi.shared.updateDriverLocation();
    fetchLocation();
    initialize();

   
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure the widget tree is built before calling registerSocket or accessing Bloc
      registerSocket();
    });
    super.initState();
  }

  // * Checking Driver Offline or Online
  checkDriverStatus() async {
    try {
      var response = await statusApi.getStatusDriver();
      setState(() {
        switchButton = response.data?.isAvailable == 1;
      });
    } catch (e) {
      tlog("Error $e");
    }
  }

  void initialize() async {
    await checkDriverStatus();
    await Taxi.shared.init();
    _updateMarkerPosition();
    if (!isCameraInitialized) {
      mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(driverCurrentLat, driverCurrentLng),
        ),
      );
      isCameraInitialized = true; // Camera is now initialized
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

  void _updateMarkerPosition() async {
    setState(() {
      _markers.removeWhere(
        (marker) => marker.markerId == const MarkerId("driverMarker"),
      );
      _markers.add(Taxi.shared.driverMarker!);
    });
  }

  Widget buildSwitchButton() {
    return FlutterSwitch(
      activeTextColor: AppColors.light4,
      inactiveTextColor: AppColors.error,
      activeColor: AppColors.success,
      inactiveColor: AppColors.light1,
      activeText: "Online".tr(),
      inactiveText: "Offline".tr(),
      value: Taxi.shared.isDriverActive, //switchButton,
      valueFontSize: 14.0,
      width: 105,
      borderRadius: 15,
      height: 30,
      toggleSize: 35,
      padding: 3,
      showOnOff: true,

      onToggle: (val) async {
        Taxi.shared.notifyBooking(title: "Complete Ride");
        // Taxi.shared.toggleDriverAvailable(isAvailable: val);
        // setState(() {
        //   Taxi.shared.isDriverActive = val;
        //     switchButton = !switchButton;
        // });
      },
    );
  }

  Widget buildGoogleMap() {
    return driverCurrentLat == 0.0 || driverCurrentLng == 0.0
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            trafficEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(driverCurrentLat,
                  driverCurrentLng), // Default position if location is unavailable
              zoom: 17.0,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              if (!isCameraInitialized) {
                controller.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(driverCurrentLat, driverCurrentLng),
                  ),
                );
                isCameraInitialized = true;
              }
            },
          );
  }

  Widget buildCustomerLocationWidget(
      {required VoidCallback onConfirm,
      required String time,
      required String currentLocation,
      required String destination,
      required String name,
      required String paymentType,
      required String profile}) {
    return Column(
      children: [
        Text("Customer Location",
            style:
                ThemeConstands.font16Regular.copyWith(color: AppColors.dark1)),
        Text(time,
            style:
                ThemeConstands.font16Regular.copyWith(color: AppColors.dark3)),
        const Divider(height: 10, thickness: 0.5, color: AppColors.dark4),
        Row(
          children: [
            CircleAvatar(radius: 30.0, backgroundImage: NetworkImage(profile)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: ThemeConstands.font20SemiBold
                        .copyWith(color: AppColors.dark1)),
                Text(paymentType,
                    style: ThemeConstands.font14Regular
                        .copyWith(color: AppColors.dark1)),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.light1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Current Location Passenger",
                  style: ThemeConstands.font14Regular
                      .copyWith(color: AppColors.dark2)),
              Text(currentLocation,
                  style: ThemeConstands.font16SemiBold
                      .copyWith(color: AppColors.dark1)),
              const SizedBox(height: 10),
              Text("Destination Passenger",
                  style: ThemeConstands.font14Regular
                      .copyWith(color: AppColors.dark2)),
              Text(destination,
                  style: ThemeConstands.font16SemiBold
                      .copyWith(color: AppColors.dark1)),
            ],
          ),
        ),
        Row(
          children: [
            FBTNWidget(
                onPressed: () {},
                color: AppColors.dark1,
                textColor: AppColors.light4,
                label: "Cancel"),
            Expanded(
              child: FBTNWidget(
                  onPressed: onConfirm,
                  color: AppColors.red,
                  textColor: AppColors.light4,
                  label: "Accept"),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentDriverInfoBloc, CurrentDriverInfoState>(
      listener: (context, state) {
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
                      lngDriver: double.parse(dataDriver
                          .driver!.lastLocation!.longitude
                          .toString()),
                      // desLat: data["destination"]['latitude'],
                      // desLng: data["destination"]['longitude'],
                      passengerId: dataDriver.passenger!.id.toString(),
                    ),
                  ));
            }
          }
        } else {
          tlog("Current Driver Fail");
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello Kosal",
                      style: ThemeConstands.font18SemiBold
                          .copyWith(color: AppColors.dark1)),
                  buildSwitchButton(),
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
}

Future<BitmapDescriptor> loadCustomMarker({required String imagePath}) async {
  BitmapDescriptor convertMarkerIcon = await BitmapDescriptor.asset(
    const ImageConfiguration(size: Size(48, 48)),
    imagePath,
  );
  return convertMarkerIcon;
}
