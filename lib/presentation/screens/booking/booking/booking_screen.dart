import 'package:com.tara_driver_application/core/helper/get_address_latlng_helper.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';
import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/presentation/screens/booking/booking/bloc/booking_bloc.dart';
import 'package:com.tara_driver_application/presentation/screens/home_screen/home_screen.dart';
import 'package:com.tara_driver_application/presentation/widgets/count_down_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/fbtn_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/loading_widget.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class BookingScreen extends StatefulWidget {
  final String bookingId;
  final String passengerId;
  double lat;
  double lng;
  double? desLat;
  double? desLng;

  BookingScreen({
    super.key,
    required this.bookingId,
    required this.lat,
    required this.lng,
    this.desLat,
    this.desLng,
    required this.passengerId,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with WidgetsBindingObserver {
  late BitmapDescriptor driverMarker;
  late BitmapDescriptor passengerMarker;
  late BitmapDescriptor destinationPassengerMarker;
  GoogleMapController? _mapController;

  bool isConfirmBooking = false;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  // Passenger LatLng

  double pLat = 11.574606;
  double pLng = 104.917769;

  double pDesLat = 11.570693;
  double pDesLng = 104.915758;

  Location location = Location();

  // PlaceMarker
  String currentPassengerPM = "";
  String destinationPassengerPM = "";

  @override
  void initState() {
    super.initState();

    polylinePoints = PolylinePoints();
    setupBackgroundLocationTracking();
    getAddressPlaceMarker();
    syncMarker();
    _drawPolylines();
  }

  Future<void> setupBackgroundLocationTracking() async {
    await location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen((locationData) {
      setState(() {
        widget.lat = locationData.latitude!;
        widget.lng = locationData.longitude!;
      });
      // currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

      tlog("messagessssesse ${widget.lat} -- ${widget.lng}");
    });
  }

  void syncMarker() async {
    driverMarker =
        await loadCustomMarker(imagePath: "assets/marker/car_marker.png");
    passengerMarker =
        await loadCustomMarker(imagePath: 'assets/marker/passenger_marker.png');
    destinationPassengerMarker =
        await loadCustomMarker(imagePath: 'aassets/marker/location_tuktuk.png');

    _addMarker(pLat, pLng, 'passengerMarker', passengerMarker);
    _addMarker(
        pDesLat, pDesLng, "destinationMarker", destinationPassengerMarker);

    double driverLat = Taxi.shared.currentLocation!.latitude;
    double driverLng = Taxi.shared.currentLocation!.longitude;

    _addMarker(driverLat, driverLng, 'driverMarker', driverMarker);
    setState(() {});
  }

  void _addMarker(double lat, double lng, String title, BitmapDescriptor icon) {
    final marker = Marker(
      markerId: MarkerId(title),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title),
      icon: icon,
    );
    _markers.add(marker);
    setState(() {});
  }

  Future<void> _drawPolylines() async {
    List<Map<String, LatLng>> routes = [
      {
        'start': LatLng(widget.lat,
        widget.lng
          //Taxi.shared.driverLocation!.latitude!,
            // Taxi.shared.driverLocation!.longitude!
            ),
        'end': LatLng(pLat, pLng),
      },
      {
        'start': LatLng(pLat, pLng),
        'end': LatLng(pDesLat, pDesLng),
      },
    ];

    for (int i = 0; i < routes.length; i++) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: AppConstant.googleKeyApi,
        request: PolylineRequest(
          origin: PointLatLng(
              routes[i]['start']!.latitude, routes[i]['start']!.longitude),
          destination: PointLatLng(
              routes[i]['end']!.latitude, routes[i]['end']!.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.status == 'OK' && result.points.isNotEmpty) {
        List<LatLng> polylineCoordinates = [];
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: PolylineId("route_${i + 1}"),
              color: Colors.red,
              //  i == 0
              //     ? Colors.blue
              //     : i == 1
              //         ? Colors.green
              //         : Colors.red,
              points: polylineCoordinates,
              width: 5,
            ),
          );
        });
      } else {
        tlog("Error drawing polyline $i: ${result.errorMessage}");
      }
    }
  }

  void _turnRight() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(Taxi.shared.driverLocation!.latitude!,
                Taxi.shared.driverLocation!.longitude!),
            zoom: 19.151926040649414,
            tilt: 0.0,
            bearing: Taxi.shared.driverLocation!.latitude!,
          ),
        ),
      );
    }
  }

  void getAddressPlaceMarker() async {
    currentPassengerPM = await getAddressFromLatLng(pLat, pLng);
    destinationPassengerPM = await getAddressFromLatLng(pDesLat, pDesLng);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(isConfirmBooking == false
            ? "Request Booking"
            : "Accepted Passenger"),
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingLoading) {
            tlog("Booking Loading");
          } else if (state is CancelBookingSuccess) {
            tlog("Cancel Booking Successfully");
          } else if (state is ConfirmBookingSuccess) {
            setState(() {
              isConfirmBooking = true;
            });
            tlog("Confirm Booking Successfully");
          } else {
            tlog("Booking Fail");
          }
        },
        builder: (context, state) {
          bool isLoading = state is BookingLoading;
          return Stack(
            children: [
              Container(
                color: AppColors.light1,
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  indoorViewEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  mapToolbarEnabled: true,
                  polylines: _polylines,
                  markers: _markers,
                  initialCameraPosition: CameraPosition(
                    bearing: 192.8334901395799,
                    target: LatLng(Taxi.shared.currentLocation!.latitude,
                        Taxi.shared.currentLocation!.longitude),
                    tilt: 0.0,
                    zoom: 17.151926040649414,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                ),
              ),
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(),
              ),
              isConfirmBooking != true
                  ? const Positioned(
                      top: 60,
                      left: 0,
                      right: 0,
                      child: SmoothCircularCountdown(
                        countDuration: 900,
                        isPop: true,
                      ),
                    )
                  : const SizedBox(),
              isConfirmBooking == false
                  ? rideRequestWidget(context)
                  : arrivedPassengerWidget(context),
              if (isLoading) const Positioned(child: LoadingWidget()),
            ],
          );
        },
      ),
    );
  }

  Positioned rideRequestWidget(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: MediaQuery.of(context).size.height / 2.2,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(.2)),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    "Ride Request",
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const Divider(
                  thickness: .1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Passenger",
                            style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Cash Payment",
                            style: AppTextStyles.bodyDark.copyWith(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: .1,
                ),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left column with icons
                        SizedBox(
                          width: 30,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Icon(Icons.location_city, size: 18),
                              SvgPicture.asset(
                                  "assets/icon/svg/current_location.svg",
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.cover),
                              const SizedBox(
                                  height:
                                      40), // Spacer alternative to creatNe space between icons
                              widget.desLat != null && widget.desLng != null
                                  ? SvgPicture.asset(
                                      "assets/icon/svg/bxs_map.svg",
                                      width: 32,
                                      height: 32,
                                      fit: BoxFit.cover)
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 18),

                        // Right column with location texts
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top location text
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Current Location Passenger",
                                    style: AppTextStyles.bodyDark.copyWith(
                                      color: AppColors.dark3,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    " $currentPassengerPM  ",
                                    style: AppTextStyles.bodyDark.copyWith(
                                      color: AppColors.dark1,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                              // Bottom destination text
                              const SizedBox(
                                height: 12,
                              ),
                              widget.desLat != null && widget.desLng != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Destination Location",
                                          style:
                                              AppTextStyles.bodyDark.copyWith(
                                            color: AppColors.dark3,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "${widget.desLat} - ${widget.desLng}",
                                          style:
                                              AppTextStyles.bodyDark.copyWith(
                                            color: AppColors.dark1,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FBTNWidget(
                        onPressed: () {
                          BlocProvider.of<BookingBloc>(context).add(
                            CanceBookingEvent(
                                rideId: int.parse(widget.bookingId)),
                          );
                        },
                        color: AppColors.dark1,
                        textColor: AppColors.light4,
                        label: "Cancel",
                        enableWidth: false,
                      ),
                      const Spacer(),
                      isConfirmBooking == false
                          ? Expanded(
                              child: FBTNWidget(
                                onPressed: () {
                                  _turnRight();
                                  BlocProvider.of<BookingBloc>(context).add(
                                    ConfirmBookingEvent(
                                      rideId: int.parse(widget.bookingId),
                                      driverId: AppConstant.driverId,
                                      bookingCode: widget.bookingId,
                                      passengerId: widget.passengerId,
                                      currentLat: widget.lat,
                                      currentLng: widget.lng,
                                      destinationLng: widget.desLat,
                                      destinationLat: widget.desLng,
                                    ),
                                  );
                                },
                                color: AppColors.main,
                                textColor: AppColors.light4,
                                label: "Accept",
                                enableWidth: false,
                              ),
                            )
                          : Expanded(
                              child: FBTNWidget(
                                onPressed: () {},
                                color: AppColors.main,
                                textColor: AppColors.light4,
                                label: "Arrived Passenger",
                                enableWidth: true,
                                width: 400,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned arrivedPassengerWidget(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: MediaQuery.of(context).size.height / 3.2,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(.2)),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Navigate to Passenger",
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const Divider(
                  thickness: .1,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Passenger",
                            style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Cash Payment",
                            style: AppTextStyles.bodyDark.copyWith(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: .1,
                  color: Colors.grey,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FBTNWidget(
                        onPressed: () {
                          BlocProvider.of<BookingBloc>(context).add(
                            CanceBookingEvent(
                                rideId: int.parse(widget.bookingId)),
                          );
                        },
                        color: AppColors.dark1,
                        textColor: AppColors.light4,
                        label: "Cancel",
                        enableWidth: false,
                      ),
                      const Spacer(),
                      Expanded(
                        child: FBTNWidget(
                          onPressed: () {
                            Taxi.shared.calculateFare(
                                startLatitude:
                                    Taxi.shared.driverLocation!.latitude!,
                                startLongitude:
                                    Taxi.shared.driverLocation!.longitude!,
                                endLatitude: pDesLat,
                                endLongitude: pDesLng);
                          },
                          color: AppColors.main,
                          textColor: AppColors.light4,
                          label: "Arrived Passenger",
                          enableWidth: true,
                          width: 400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






// class BookingScreen extends StatefulWidget {
//   final String bookingId;
//   final String passengerId;
//   final double lat;
//   final double lng;
//   final double? desLat;
//   final double? desLng;

//   BookingScreen({
//     super.key,
//     required this.bookingId,
//     required this.lat,
//     required this.lng,
//     this.desLat,
//     this.desLng,
//     required this.passengerId,
//   });

//   @override
//   State<BookingScreen> createState() => _BookingScreenState();
// }

// class _BookingScreenState extends State<BookingScreen>
//     with WidgetsBindingObserver {
//   late BitmapDescriptor driverMarker;
//   late BitmapDescriptor passengerMarker;
//   late BitmapDescriptor destinationPassengerMarker;
//   GoogleMapController? _mapController;

//   bool isConfirmBooking = false;
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polylines = {};
//   List<LatLng> polylineCoordinates = [];
//   late PolylinePoints polylinePoints;

// // Destination Driver
//   double pDesLat = 11.570693;
//   double pDesLng = 104.915758;

//   @override
//   void initState() {
//     super.initState();
//     polylinePoints = PolylinePoints();
//     _initializeMarkers();
//     _updatePolyline();
//     printDebug();
//   }

//   void printDebug(){
//     tlog("Current Location Widget: ${widget.lat}-${widget.lng}");
//     tlog("Destination Location Widget: ${widget.}-${widget.lng}");
    
//   }

//   /// Load markers and add to the map
//   void _initializeMarkers() async {
//     driverMarker =
//         await loadCustomMarker(imagePath: "assets/marker/car_marker.png");
//     passengerMarker =
//         await loadCustomMarker(imagePath: "assets/marker/passenger_marker.png");
//     destinationPassengerMarker = await loadCustomMarker(
//         imagePath: "assets/marker/location_tuktuk.png");

//     // Add static markers for passenger and destination
//     _addMarker(widget.lat, widget.lng, 'Passenger', passengerMarker);
//     if (widget.desLat != null && widget.desLng != null) {
//       _addMarker(
//         widget.desLat!,
//         widget.desLng!,
//         'Destination',
//         destinationPassengerMarker,
//       );
//     }

//     // Add the driver's initial marker
//     _updateDriverMarker(
//         LatLng(Taxi.shared.driverLocation!.latitude!,
//             Taxi.shared.driverLocation!.longitude!));
//   }

//   /// Add a new marker to the map
//   void _addMarker(double lat, double lng, String id, BitmapDescriptor icon) {
//     final marker = Marker(
//       markerId: MarkerId(id),
//       position: LatLng(lat, lng),
//       infoWindow: InfoWindow(title: id),
//       icon: icon,
//     );
//     _markers.add(marker);
//     setState(() {});
//   }

//   /// Update driver's marker dynamically
//   void _updateDriverMarker(LatLng newPosition) {
//     const driverMarkerId = MarkerId('Driver');
//     _markers.removeWhere((marker) => marker.markerId == driverMarkerId);
//     _addMarker(newPosition.latitude, newPosition.longitude, 'Driver',
//         driverMarker);

//     // Move camera to follow the driver
//     _mapController?.animateCamera(
//       CameraUpdate.newLatLng(newPosition),
//     );
//   }

//   /// Draw polylines for the route
//   Future<void> _updatePolyline() async {
//     final start = LatLng(Taxi.shared.driverLocation!.latitude!,
//         Taxi.shared.driverLocation!.longitude!);
//     final end = widget.desLat != null && widget.desLng != null
//         ? LatLng(widget.desLat!, widget.desLng!)
//         : LatLng(widget.lat, widget.lng);

//     final PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleApiKey: AppConstant.googleKeyApi,
//       request: PolylineRequest(
//         origin: PointLatLng(start.latitude, start.longitude),
//         destination: PointLatLng(end.latitude, end.longitude),
//         mode: TravelMode.driving,
//       ),
//     );

//     if (result.status == 'OK' && result.points.isNotEmpty) {
//       polylineCoordinates.clear();
//       for (var point in result.points) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       }
//       setState(() {
//         _polylines.add(Polyline(
//           polylineId: const PolylineId('Route'),
//           color: Colors.blue,
//           width: 5,
//           points: polylineCoordinates,
//         ));
//       });
//     } else {
//       debugPrint("Polyline error: ${result.errorMessage}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(isConfirmBooking ? "Accepted Passenger" : "Request Booking"),
//       ),
//       body: BlocConsumer<BookingBloc, BookingState>(
//         listener: (context, state) {
//           if (state is ConfirmBookingSuccess) {
//             setState(() => isConfirmBooking = true);
//           }
//         },
//         builder: (context, state) {
//           final isLoading = state is BookingLoading;
//           return Stack(
//             children: [
//               GoogleMap(
//                 mapType: MapType.normal,
//                 myLocationEnabled: true,
//                 markers: _markers,
//                 polylines: _polylines,
//                 initialCameraPosition: CameraPosition(
//                   target: LatLng(Taxi.shared.driverLocation!.latitude!,
//                       Taxi.shared.driverLocation!.longitude!),
//                   zoom: 14,
//                 ),
//                 onMapCreated: (controller) => _mapController = controller,
//               ),
//               if (isLoading) const Center(child: CircularProgressIndicator()),
//               // isConfirmBooking
//                   // ? arrivedPassengerWidget(context)
//                   // : rideRequestWidget(context),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   /// Placeholder for the widget displayed during a ride request
//   // Positioned rideRequestWidget(BuildContext context) {
//     // Your existing ride request widget code
//     // return Positioned();
//   // }

//   /// Placeholder for the widget displayed once the passenger has arrived
//   // Positioned arrivedPassengerWidget(BuildContext context) {
//     // Your existing arrived passenger widget code
//     // return Positioned(...);
//   // }
// }
