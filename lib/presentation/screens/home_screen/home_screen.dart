// import 'package:com.tara_driver_application/core/storages/get_storages.dart';
// import 'package:com.tara_driver_application/core/utils/app_constant.dart';
// import 'package:com.tara_driver_application/core/utils/generate_marker.dart';
// import 'package:com.tara_driver_application/presentation/blocs/get_current_driver_info_bloc.dart';
// import 'package:com.tara_driver_application/presentation/screens/home_screen/home_service.dart';
// import 'package:com.tara_driver_application/taxi_single_ton/init_socket.dart';
// import 'package:dotted_line/dotted_line.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:com.tara_driver_application/core/resources/asset_resource.dart';
// import 'package:com.tara_driver_application/core/theme/colors.dart';
// import 'package:com.tara_driver_application/core/theme/text_styles.dart';
// import 'package:com.tara_driver_application/presentation/widgets/expand_widget.dart';
// import 'package:com.tara_driver_application/presentation/widgets/fbtn_widget.dart';
// import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
// import 'package:location/location.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
//   bool switchButton = true;
//   final Set<Marker> _markers = {};
//   late BitmapDescriptor customIcon;

//   LocationData? currentLocation;
//   final Location location = Location();
//   GoogleMapController? mapController;
//   final DriverSocketService driverSocketService = DriverSocketService();

//   @override
//   void initState() {
//     super.initState();
//     Taxi.shared.requestLocationPermission(context);
//     Taxi.shared.checkDriverAvailability();
//     driverSocketService.connectToSocket(
//         AppConstant.socketBasedUrl, AppConstant.driverId, "Driver",
//         context: context);
//     Taxi.shared.setupBackgroundChange();
//     _getCurrentLocation();

//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     if (state == AppLifecycleState.resumed) {
//       // BlocProvider.of<CurrentDriverInfoBloc>(context).add(GetCurrentInfoEvent());
//     }
//   }

//   void _updateMarkerPosition(double lat, double long) {
//     _markers.removeWhere(
//       (marker) => marker.markerId == const MarkerId("driverMarker"),
//     );

//     Marker updatedDriverMarker = Marker(
//       markerId: const MarkerId("driverMarker"),
//       position: LatLng(lat, long),
//       icon: customIcon,
//       infoWindow: const InfoWindow(title: 'Driver'),
//     );

//     _markers.add(updatedDriverMarker);

//     setState(() {});
//   }

//   void _getCurrentLocation() async {
//     currentLocation = await location.getLocation();
//     setState(() {
//       Taxi.shared.driverLocation = currentLocation;
//     });
//     if (currentLocation != null) {
//       customIcon =
//           await loadCustomMarker(imagePath: "assets/marker/car_marker.png");
//     }

//     await Taxi.shared.getCurrentLocationAndCreateMarker();
//     // Start listening to location changes
//     location.onLocationChanged.listen((LocationData newLocation) {
//       setState(() {
//         currentLocation = newLocation;
//       });

//       _updateMarkerPosition(newLocation.latitude!, newLocation.longitude!);

//       if (mapController != null) {
//         mapController!.animateCamera(CameraUpdate.newLatLng(
//           LatLng(newLocation.latitude!, newLocation.longitude!),
//         ));
//       }
//     });
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<CurrentDriverInfoBloc, CurrentDriverInfoState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         final bloc = context.read<CurrentDriverInfoBloc>();
//         return Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Hello Kosal",
//                     style: ThemeConstands.font18SemiBold
//                         .copyWith(color: AppColors.dark1),
//                   ),
//                   FlutterSwitch(
//                     activeTextColor: AppColors.light4,
//                     inactiveTextColor: AppColors.error,
//                     activeColor: AppColors.success,
//                     inactiveColor: AppColors.light1,
//                     activeText: "Online".tr(),
//                     inactiveText: "Offline".tr(),
//                     value: switchButton,
//                     valueFontSize: 14.0,
//                     width: 105,
//                     borderRadius: 15,
//                     height: 30,
//                     toggleSize: 35,
//                     padding: 3,
//                     showOnOff: true,
//                     onToggle: (val) async {
//                       await StorageGet.getDriverData();
//                       setState(() {
//                         switchButton = !switchButton;
//                       });
//                     },
//                   )
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Stack(
//                 children: [
//                   Container(
//                     color: AppColors.light1,
//                     child: GoogleMap(
//                       mapType: MapType.normal,
//                       myLocationEnabled: true,
//                       indoorViewEnabled: true,
//                       myLocationButtonEnabled: true,
//                       compassEnabled: true,
//                       zoomControlsEnabled: true,
//                       zoomGesturesEnabled: true,
//                       mapToolbarEnabled: true,
//                       initialCameraPosition: CameraPosition(
//                         bearing: 192.8334901395799,
//                         target: currentLocation != null
//                             ? LatLng(currentLocation!.latitude!,
//                                 currentLocation!.longitude!)
//                             : const LatLng(11.5746909, 104.8930405),
//                         tilt: 0.0,
//                         zoom: 17.151926040649414,
//                       ),
//                       markers: _markers,
//                       onMapCreated: (GoogleMapController controller) {
//                         mapController = controller;
//                         if (currentLocation != null) {
//                           controller.animateCamera(
//                             CameraUpdate.newLatLng(
//                               LatLng(currentLocation!.latitude!,
//                                   currentLocation!.longitude!),
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                   bloc.isLoading == true
//                       ? const Positioned(
//                           top: 0,
//                           bottom: 0,
//                           left: 0,
//                           right: 0,
//                           child: Center(child: CircularProgressIndicator()))
//                       : const SizedBox(),
//                 ],
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }

//   Widget rideRequest(
//       {required VoidCallback comfirm,
//       required String title,
//       required bool userDirection,
//       required String currentLocation,
//       required String locationWheretogo,
//       required String name,
//       required String paymentTypeName,
//       required String profile}) {
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.only(bottom: 5),
//           child: Text(
//             title,
//             style:
//                 ThemeConstands.font16Regular.copyWith(color: AppColors.dark1),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         const Divider(
//           height: 10,
//           thickness: 0.5,
//           color: AppColors.dark4,
//         ),
//         Row(
//           children: [
//             CircleAvatar(
//               radius: 30.0,
//               backgroundImage: NetworkImage(profile),
//               backgroundColor: Colors.transparent,
//             ),
//             Container(
//               alignment: Alignment.centerLeft,
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: ThemeConstands.font20SemiBold
//                         .copyWith(color: AppColors.dark1),
//                   ),
//                   Text(
//                     paymentTypeName,
//                     style: ThemeConstands.font14Regular
//                         .copyWith(color: AppColors.dark1),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         Container(
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(width: 1, color: AppColors.light1),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                   padding: const EdgeInsets.only(left: 28),
//                   child: Text(
//                     "Current Location Passenger",
//                     style: ThemeConstands.font14Regular
//                         .copyWith(color: AppColors.dark2),
//                   )),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SvgPicture.asset(
//                     ImageAssets.book_outline,
//                     width: 20,
//                     color: AppColors.dark1,
//                   ),
//                   const SizedBox(
//                     width: 8,
//                   ),
//                   Expanded(
//                       child: Text(
//                     currentLocation,
//                     style: ThemeConstands.font16SemiBold
//                         .copyWith(color: AppColors.dark1),
//                   )),
//                 ],
//               ),
//               userDirection == true
//                   ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.only(left: 9),
//                           alignment: Alignment.centerLeft,
//                           child: const DottedLine(
//                             alignment: WrapAlignment.start,
//                             lineLength: 30,
//                             direction: Axis.vertical,
//                             lineThickness: 1,
//                             dashColor: AppColors.dark1,
//                           ),
//                         ),
//                         Padding(
//                             padding: const EdgeInsets.only(left: 28),
//                             child: Text(
//                               "Destination Passenger",
//                               style: ThemeConstands.font14Regular
//                                   .copyWith(color: AppColors.dark2),
//                             )),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             SvgPicture.asset(
//                               ImageAssets.book_outline,
//                               width: 20,
//                               color: AppColors.red,
//                             ),
//                             const SizedBox(
//                               width: 8,
//                             ),
//                             Expanded(
//                                 child: Text(
//                               locationWheretogo,
//                               style: ThemeConstands.font16SemiBold
//                                   .copyWith(color: AppColors.dark1),
//                             )),
//                           ],
//                         ),
//                       ],
//                     )
//                   : const SizedBox(),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 18,
//         ),
//         Row(
//           children: [
//             FBTNWidget(
//               onPressed: () {},
//               color: AppColors.dark1,
//               textColor: AppColors.light4,
//               label: "Cancel",
//               enableWidth: false,
//             ),
//             const SizedBox(
//               width: 28,
//             ),
//             Expanded(
//               child: FBTNWidget(
//                 onPressed: comfirm,
//                 color: AppColors.red,
//                 textColor: AppColors.light4,
//                 label: "Accept",
//                 enableWidth: false,
//               ),
//             )
//           ],
//         )
//       ],
//     );
//   }
// }

// Widget customerLocation(
//     {required VoidCallback comfirm,
//     required String time,
//     required String currentLocation,
//     required String locationWheretogo,
//     required String name,
//     required String paymentTypeName,
//     required String profile}) {
//   return Container(
//     child: Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.only(bottom: 5),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Customer Location",
//                 style: ThemeConstands.font16Regular
//                     .copyWith(color: AppColors.dark1),
//                 textAlign: TextAlign.center,
//               ),
//               Text(
//                 time,
//                 style: ThemeConstands.font16Regular
//                     .copyWith(color: AppColors.dark3),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//         const Divider(
//           height: 10,
//           thickness: 0.5,
//           color: AppColors.dark4,
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 30.0,
//                     backgroundImage: NetworkImage(profile),
//                     backgroundColor: Colors.transparent,
//                   ),
//                   Container(
//                     alignment: Alignment.centerLeft,
//                     margin: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           name,
//                           style: ThemeConstands.font20SemiBold
//                               .copyWith(color: AppColors.dark1),
//                         ),
//                         Text(
//                           paymentTypeName,
//                           style: ThemeConstands.font14Regular
//                               .copyWith(color: AppColors.dark1),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                   border: Border.all(color: AppColors.error, width: 1),
//                   shape: BoxShape.circle),
//               child: const Icon(
//                 Icons.call,
//                 size: 28,
//                 color: AppColors.error,
//               ),
//             ),
//           ],
//         ),
//         Container(
//           margin: const EdgeInsets.symmetric(vertical: 10),
//           child: expandCustom(
//             colorButtonExpand: AppColors.light4,
//             isClick: true,
//             isExpand: false,
//             onPressed: () {},
//             childHeader: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Where to go?",
//                   style: ThemeConstands.font16Regular
//                       .copyWith(color: AppColors.dark1),
//                   textAlign: TextAlign.center,
//                 ),
//                 Container(
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(
//                         ImageAssets.book_outline,
//                         width: 20,
//                         color: AppColors.dark1,
//                       ),
//                       Container(
//                         alignment: Alignment.centerLeft,
//                         child: const DottedLine(
//                           alignment: WrapAlignment.start,
//                           lineLength: 30,
//                           direction: Axis.horizontal,
//                           lineThickness: 1,
//                           dashColor: AppColors.dark1,
//                         ),
//                       ),
//                       SvgPicture.asset(
//                         ImageAssets.book_outline,
//                         width: 20,
//                         color: AppColors.red,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Icon(
//                   Icons.keyboard_arrow_down_sharp,
//                   size: 28,
//                 )
//               ],
//             ),
//             widget: Container(
//               child: Column(
//                 children: [
//                   Container(
//                     height: 70,
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 18,
//         ),
//         Row(
//           children: [
//             FBTNWidget(
//               onPressed: () {},
//               color: AppColors.dark1,
//               textColor: AppColors.light4,
//               label: "Cancel",
//               enableWidth: false,
//             ),
//             const SizedBox(
//               width: 28,
//             ),
//             Expanded(
//               child: FBTNWidget(
//                 onPressed: comfirm,
//                 color: AppColors.red,
//                 textColor: AppColors.light4,
//                 label: "Arrive customer",
//                 enableWidth: false,
//               ),
//             )
//           ],
//         )
//       ],
//     ),
//   );
// }

// Future<BitmapDescriptor> loadCustomMarker({required String imagePath}) async {
//   BitmapDescriptor convertMarkerIcon = await BitmapDescriptor.asset(
//     const ImageConfiguration(size: Size(48, 48)),
//     imagePath,
//   );
//   return convertMarkerIcon;
// }

import 'dart:async';

import 'package:com.tara_driver_application/core/storages/get_storages.dart';
import 'package:com.tara_driver_application/core/storages/set_storages.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';
import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/data/datasources/set_status_api.dart';
import 'package:com.tara_driver_application/presentation/blocs/get_current_driver_info_bloc.dart';
import 'package:com.tara_driver_application/presentation/screens/calculate_fee_screen.dart';
// import 'package:com.tara_driver_application/presentation/screens/booking/booking/booking_screen.dart';
import 'package:com.tara_driver_application/taxi_single_ton/init_socket.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
  LocationData? currentLocation;
  LatLng? savedLocation;
  final Location location = Location();
  GoogleMapController? mapController;
  final DriverSocketService driverSocketService = DriverSocketService();
  SetDriverStatusApi statusApi = SetDriverStatusApi();

  bool isCameraInitialized = false;

  @override
  void initState() {
    // setState(() {
    //   Timer.periodic(const Duration(seconds: 10), (Timer t) => Taxi.shared.updateCurrentLocation());
    // });
    super.initState();
    initialize();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // BlocProvider.of<CurrentDriverInfoBloc>(context).add(GetCurrentInfoEvent());
    }
  }

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
     driverSocketService.connectToSocket(
        AppConstant.socketBasedUrl, "5", "Driver",
        context: context);
    await checkDriverStatus();
    await Taxi.shared.init();
   
    currentLocation = Taxi.shared.driverLocation;
    // savedLocation = await StorageGet.getSavedLocation();

    // if (savedLocation != null) {
    //   currentLocation = LocationData.fromMap({
    //     'latitude': savedLocation?.latitude,
    //     'longitude': savedLocation?.longitude,
    //   });
    // }

    if (currentLocation != null) {
      _updateMarkerPosition();
      // Save the current location to shared preferences
      await StorageSet.saveLocation(
          currentLocation!.latitude!, currentLocation!.longitude!);

      // Initialize camera only once
      if (!isCameraInitialized) {
        mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          ),
        );
        isCameraInitialized = true; // Camera is now initialized
      }
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

  void navigateBooking() {
    // driverSocketService
    //     .showNewRideAlert({"passengerId": "1234", "booking_code": "123"});
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => BookingScreen(
    //       bookingId: "123",
    //       lat: 11.622195850500255,
    //       lng: 104.90432260877373,
    //       // desLat: data["destination"]['latitude'],
    //       // desLng: data["destination"]['longitude'],
    //       passengerId: "12",
    //     ),
    //   ),
    // );
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
        Taxi.shared.toggleDriverAvailable(isAvailable: val);
        setState(() {
          Taxi.shared.isDriverActive = val;
        });
        setState(() {
          switchButton = !switchButton;
        });
      },
    );
  }

  Widget buildGoogleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      compassEnabled: true,
      trafficEnabled: true,
      initialCameraPosition: CameraPosition(
        target: currentLocation != null
            ? LatLng(currentLocation!.latitude??11.5746909, currentLocation!.longitude??104.8930405)
            : const LatLng(11.5746909,104.8930405), // Default position if location is unavailable
        zoom: 17.0,
      ),
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
        // Only animate camera if currentLocation is available and not initialized
        if (currentLocation != null && !isCameraInitialized) {
          controller.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
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
              if(dataDriver != null){
                if(dataDriver.status == 6){
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CalculateFeeScreen(dataDriverInfo: dataDriver,routFrom: "FromHome",startAddress: dataDriver.startAddress.toString(),endAddress: dataDriver.endAddress.toString())));
                }
              }
            } else {
              setState(() {
              });
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
                  Text("Hello Kosal",style: ThemeConstands.font18SemiBold.copyWith(color: AppColors.dark1)),
                  buildSwitchButton(),
                ],
              ),
            ),
            Expanded(child: buildGoogleMap()),
            if (state is CurrentDriverLoading)
              const SizedBox(),
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
