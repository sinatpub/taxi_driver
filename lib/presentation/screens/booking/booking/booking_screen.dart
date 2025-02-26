import 'package:com.tara_driver_application/core/helper/get_address_latlng_helper.dart';
import 'package:com.tara_driver_application/core/storages/get_storages.dart';
import 'package:com.tara_driver_application/core/theme/colors.dart';
import 'package:com.tara_driver_application/core/theme/text_styles.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';
import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/data/models/register_model.dart';
import 'package:com.tara_driver_application/presentation/screens/booking/booking/bloc/booking_bloc.dart';
import 'package:com.tara_driver_application/presentation/screens/calculate_fee_screen.dart';
import 'package:com.tara_driver_application/presentation/screens/home_screen/home_screen.dart';
import 'package:com.tara_driver_application/presentation/screens/nav_screen.dart';
import 'package:com.tara_driver_application/presentation/widgets/count_down_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/error_dialog_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/fbtn_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/loading_widget.dart';
import 'package:com.tara_driver_application/presentation/widgets/yesno_dialog_widget.dart';
import 'package:com.tara_driver_application/taxi_single_ton/init_socket.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingScreen extends StatefulWidget {
  final String bookingId;
  final String bookingCode;
  final String passengerId;
  double latPassenger;
  double lngPassenger;
  double? desLatPassenger;
  double? desLngPassenger;
  double? latDriver;
  double? lngDriver;
  int processStepBook;
  int timeOut;
  String namePassanger;
  String imagePassanger;
  String phonePassanger;

  BookingScreen({
    super.key,
    required this.bookingId,
    required this.bookingCode,
    required this.latPassenger,
    required this.lngPassenger,
    required this.processStepBook,
    this.desLatPassenger,
    this.desLngPassenger,
    this.latDriver,
    this.lngDriver,
    required this.timeOut,
    required this.passengerId,
    required this.namePassanger,
    required this.phonePassanger,
    required this.imagePassanger,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late BitmapDescriptor driverMarker;
  late BitmapDescriptor passengerMarker;
  late BitmapDescriptor destinationPassengerMarker;
  GoogleMapController? _mapController;

  bool isExpanded = false;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  Location location = Location();

  // PlaceMarker
  String currentPassengerPM = "";
  String destinationPassengerPM = "";

  int typeProcessBooking = 0;

  double currentLatDriver = 0.0;
  double currentLngDriver = 0.0;
  String currentAddressDriver = "";

  double dropLatDriver = 0.0;
  double dropLngDriver = 0.0;
  String dropAddressDriver = "";
  // * Socket Class
  DriverSocketService driverSocket = DriverSocketService();
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

  Future<void> _launchLink(String url) async {
    if (await launchUrl(Uri.parse(url))) {
    }else{
      await launchUrl(Uri.parse(url),);
    }
  }

  void getLocation() async {
    // Type  0 = initScreen, 1 = accept ,2 = arrive, 3 = start, 4 = drop;
    Position? position = await Taxi.shared.checkCurrentLocation();
    if (position != null) {

    // ==============  Accept acion ======================
      if (typeProcessBooking == 1) {
        // currentAddressDriver = await getAddressFromLatLng(position.latitude, position.longitude);
        // setState(() {
        //   currentLatDriver = position.latitude;
        //   currentLngDriver = position.longitude;
        // });
        // BlocProvider.of<BookingBloc>(context).add(
        //   ConfirmBookingEvent(
        //     rideId: int.parse(widget.bookingId.toString()),
        //   ),
        // );
        // debugPrint("accept and get positon");
        // Logger().e(
        //     "D+++++++: $currentLatDriver-$currentLngDriver = ${widget.latPassenger} - ${widget.lngPassenger}");
        // _drawPolylines(
        //     dLocation: LatLng(currentLatDriver, currentLngDriver),
        //     pLocation: LatLng(widget.latPassenger, widget.lngPassenger));

  // ==============  Arrive acion ======================
      } else if (typeProcessBooking == 2) {
        // debugPrint("arrived");
        // currentAddressDriver =
        //     await getAddressFromLatLng(position.latitude, position.longitude);
        // setState(() {
        //   currentLatDriver = position.latitude;
        //   currentLngDriver = position.longitude;
        // });
        // BlocProvider.of<BookingBloc>(context).add(
        //   ArrivedEvent(
        //     rideId: int.parse(widget.bookingId),
        //   ),
        // );
        // _clearPolyline();
  
  // ==============  Start acion ======================
      } else if (typeProcessBooking == 3) {
        // debugPrint("start");
        // startAddressDriver =
        //     await getAddressFromLatLng(position.latitude, position.longitude);
        // setState(() {
        //   startLatDriver = position.latitude;
        //   startLngDriver = position.longitude;
        // });
        // BlocProvider.of<BookingBloc>(context).add(
        //   StartTripEvent(
        //     rideId: int.parse(widget.bookingId),
        //   ),
        // );
        // _clearPolyline();

  // ==============  Drop acion ======================
      } else if (typeProcessBooking == 4) {
        debugPrint("drop - total distance ${Taxi.shared.totalDistance}");
        dropAddressDriver =
            await getAddressFromLatLng(position.latitude, position.longitude);
        setState(() {
          dropLatDriver = position.latitude;
          dropLngDriver = position.longitude;
        });
        BlocProvider.of<BookingBloc>(context).add(CompletedTripEvent(
          distance: double.parse((Taxi.shared.totalDistance/100).toStringAsFixed(2).toString()),
          rideId: int.parse(widget.bookingId),
          endAddress: dropAddressDriver,
          endLatitude: dropLatDriver,
          endLongitude: dropLngDriver,
        ));
      } 

// ==============  New request acion ======================
      else {
        currentAddressDriver = await getAddressFromLatLng(position.latitude, position.longitude);
        if(typeProcessBooking == 0 && widget.processStepBook !=1){
           setState(() {
            widget.latDriver = position.latitude;
            widget.lngDriver = position.longitude;
            _turnRight();
            syncMarker();
            print("fasdfkads");
          });
        }
        else{
          setState(() {
            currentLatDriver = position.latitude;
            currentLngDriver = position.longitude;
            widget.latDriver = position.latitude;
            widget.lngDriver = position.longitude;
          });
          Logger().e("D+++++++: $currentLatDriver-$currentLngDriver = ${widget.latPassenger} - ${widget.lngPassenger}");
          _drawPolylines(
              dLocation: LatLng(currentLatDriver, currentLngDriver),
              pLocation: LatLng(widget.latPassenger, widget.lngPassenger));
        }
      }
      debugPrint("Lat: ${position.latitude}, Lng: ${position.longitude}");
    } else {
      debugPrint("Failed to get location.");
    }
  }

  @override
  void initState() {
    getLocation();
    registerSocket();
    super.initState();
    polylinePoints = PolylinePoints();
    syncMarker();

    Taxi.shared.setupBackgroundLocationTracking();
    Taxi.shared.updateDriverLocation();
    // Timer.periodic(const Duration(seconds: 10), (Timer t) => Taxi.shared.updateDriverLocation());
  }

  // Sync markers for driver and passenger locations
  void syncMarker() async {
    driverMarker = await loadCustomMarker(imagePath: "assets/marker/car_marker.png");
    passengerMarker = await loadCustomMarker(imagePath: 'assets/marker/passenger_marker.png');
    destinationPassengerMarker = await loadCustomMarker(imagePath: 'assets/marker/location_tuktuk.png');

    _addMarker(
        widget.processStepBook == 1 || widget.processStepBook == 2 ? widget.latPassenger : widget.latDriver!,
        widget.processStepBook == 1 || widget.processStepBook == 2 ? widget.lngPassenger : widget.lngDriver!,
        "destinationMarker", widget.processStepBook == 1? passengerMarker : driverMarker);

    getAddressPlaceMarker();
    setState(() {});
  }

  // Add a marker on the map
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

  void _drawPolylines({
    required LatLng dLocation,
    required LatLng pLocation,
  }) async {
    // Clear existing polylines
    _polylines.clear();
    // Create route
    List<Map<String, LatLng>> routes = [
      {
        'start': dLocation, // Start location (driver's location)
        'end': pLocation, // End location (passenger's location)
      },
    ];

    for (int i = 0; i < routes.length; i++) {
      // Fetch route details
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: AppConstant.googleKeyApi,
        request: PolylineRequest(
          origin: PointLatLng(routes[i]['start']!.latitude, routes[i]['start']!.longitude),
          destination: PointLatLng(routes[i]['end']!.latitude, routes[i]['end']!.longitude),
          mode: TravelMode.driving,
        ),
      );

      // Check if the route was fetched successfully
      if (result.status == 'OK' && result.points.isNotEmpty) {
        // Extract polyline coordinates
        List<LatLng> polylineCoordinates = [];
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        // Add the polyline
        _polylines.add(
          Polyline(
            polylineId: PolylineId("route_$i"),
            color: Colors.red, // Set polyline color
            points: polylineCoordinates, // Use the actual route points
            width: 5, // Set polyline width
          ),
        );
      } else {
        // Log error if route couldn't be fetched
        tlog("Error drawing polyline $i: ${result.errorMessage}");
      }
    }

    // Update the state to reflect changes on the map
    setState(() {});
  }

  _clearPolyline() {
    _polylines.clear();
  }

  // Move the camera to a static LatLng
  void _turnRight() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              widget.processStepBook == 1 || widget.processStepBook == 2 ? widget.latPassenger: widget.latDriver!,
              widget.processStepBook == 1 || widget.processStepBook == 2 ? widget.lngPassenger: widget.lngDriver!,
            ), // Use the provided LatLng for camera movement
            zoom: 19.151926040649414, // Set zoom level
          ),
        ),
      );
    }
  }

  // Get address for the place marker
  void getAddressPlaceMarker() async {
    currentPassengerPM =
        await getAddressFromLatLng(widget.latPassenger, widget.lngPassenger);
    // destinationPassengerPM = await getAddressFromLatLng(pDesLat, pDesLng);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.processStepBook == 1
            ? "Request Booking"
            : "Accepted Passenger"),
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingLoading) {
            tlog("Booking Loading");
          } else if (state is CancelBookingSuccess) {
            Navigator.pushAndRemoveUntil(context,PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => const NavScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),(route) => false,
            );
          } else if (state is ConfirmBookingSuccess) {
            var dataConfirmBooking = state.confirmBookingModel.data;
            setState(() {
              widget.processStepBook = 2;
            });
              _drawPolylines(
                dLocation: LatLng(currentLatDriver, currentLngDriver),
                pLocation: LatLng(widget.latPassenger, widget.lngPassenger));
            _turnRight();
            tlog("Confirm Booking Successfully");
            debugPrint(
                "acceptRide bookCode${widget.bookingCode} bookId${widget.bookingId} passId${widget.passengerId} lat$currentLatDriver long$currentLngDriver");
            Taxi.shared.connectAndEmitEvent(
              eventName: "acceptRide",
              data: {
                "driver_id": dataConfirmBooking!.driver!.id,
                "booking_id": dataConfirmBooking.id,
                "passengerId": dataConfirmBooking.passenger!.id,
                "location": {
                  "latitude": currentLatDriver,
                  "longitude": currentLngDriver
                },
              },
            );
          } else if (state is StartTripSuccess) {
            setState(() {
              _clearPolyline();
            });
            tlog("Start Trip Success");
            Taxi.shared.simulateTrackingDistance();
            _turnRight();
            setState(() {
              widget.processStepBook = 4;
            });
            debugPrint(
                "start bookCode${widget.bookingCode} bookId${widget.bookingId} passId${widget.passengerId} lat$currentLatDriver long$currentLngDriver");
            Taxi.shared.connectAndEmitEvent(
              eventName: "startDrive",
              data: {
                "booking_code": widget.bookingCode,
                "booking_id": widget.bookingId,
                "passengerId": widget.passengerId,
                "location": {
                  "latitude": currentLatDriver,
                  "longitude": currentLngDriver
                },
              },
            );
          } else if (state is ArriveSuccess) {
             _turnRight();
            setState(() {
              _clearPolyline();
            });
            tlog("Arrive Trip Success");
            Taxi.shared.connectAndEmitEvent(
              eventName: "rideArrival",
              data: {
                "booking_code": widget.bookingCode,
                "passengerId": widget.passengerId,
                "location": {
                  "latitude": currentLatDriver,
                  "longitude": currentLngDriver
                },
              },
            );
            setState(() {
              widget.processStepBook = 3;
            });
          } else if (state is CompletedTripSuccess) {
             _turnRight();
            setState(() {
              _clearPolyline();
            });
            debugPrint(
                "dope bookCode${widget.bookingCode} bookId${widget.bookingId} passId${widget.passengerId} lat$currentLatDriver long$currentLngDriver");
            Taxi.shared.connectAndEmitEvent(
              eventName: "dropDrive",
              data: {
                "booking_code": widget.bookingCode,
                "booking_id": widget.bookingId,
                "passengerId": widget.passengerId,
                "location": {
                  "latitude": currentLatDriver,
                  "longitude": currentLngDriver
                },
              },
            );
            setState(() async {
              var data = state.completeDriver;
              String startAddress = await getAddressFromLatLng(
                  double.parse(data.data!.startLatitude.toString()),
                  double.parse(data.data!.startLongitude.toString()));
              String endAddress = await getAddressFromLatLng(
                  double.parse(data.data!.endLatitude.toString()),
                  double.parse(data.data!.endLongitude.toString()));
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CalculateFeeScreen(
                          routFrom: "FromDropBooking",
                          dataComplete: data,
                          startAddress: startAddress,
                          endAddress: endAddress)));
            });
          } else {
            tlog("Booking Fail");
            showErrorCustomDialog(context, "Please Try Again!",
                "Please try again. Something went wrong.");
          }
        },
        builder: (context, state) {
          bool isLoading = state is BookingLoading;
          return Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: false,
                indoorViewEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                mapToolbarEnabled: true,
                polylines: _polylines,
                markers: _markers,
                initialCameraPosition: CameraPosition(
                  // bearing: 192.8334901395799,
                  target: LatLng( widget.latPassenger, widget.lngPassenger),
                  tilt: 0.0,
                  zoom: 17.151926040649414,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
              ),
              widget.processStepBook == 1
                  ? Positioned(
                      top: 60,
                      left: 0,
                      right: 0,
                      child: SmoothCircularCountdown(
                        countDuration: widget.timeOut??30,
                        isPop: true,
                      ),
                    )
                  : const SizedBox(),
              widget.processStepBook == 1
                  ? rideRequestWidget(context)
                  : widget.processStepBook == 2
                      ? arrivedPassengerWidget(context)
                      : widget.processStepBook == 3
                          ? startDriveWidget(context)
                          : Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 18),
                                color: Colors.red,
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                      typeProcessBooking = 4;
                                    });
                                    getLocation();
                                  },
                                  child: const Text("Drop Off"),
                                ),
                              ),
                            ),
              if (isLoading) const Positioned(child: LoadingWidget()),
            ],
          );
        },
      ),
    );
  }

  Widget rideRequestWidget(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: MediaQuery.of(context).size.height / 2.8,
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
                      CircleAvatar(
                                  radius: 24,
                                  child: Image.network(widget.imagePassanger),
                                ),
                      const SizedBox(
                        width: 18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.namePassanger,
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
                              SvgPicture.asset(
                                  "assets/icon/svg/current_location.svg",
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.cover),
                              const SizedBox(
                                  height:
                                      40), // Spacer alternative to creatNe space between icons
                              widget.desLatPassenger != null &&
                                      widget.desLngPassenger != null
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
                                    "Passenger Location",
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
                              widget.desLatPassenger != null &&
                                      widget.desLngPassenger != null
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
                                          "${widget.desLatPassenger} - ${widget.desLngPassenger}",
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
                          showYesNoCustomDialog(context, "Cancel Booking",
                              "Are you sure you want to cancel this booking?",
                              onYes: () {
                            BlocProvider.of<BookingBloc>(context).add(
                              CanceBookingEvent(
                                rideId: int.parse(widget.bookingId),
                              ),
                            );
                          });
                        },
                        color: AppColors.dark1,
                        textColor: AppColors.light4,
                        label: "Cancel",
                        enableWidth: true,
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                      FBTNWidget(
                        onPressed: () {
                          setState(() {
                            typeProcessBooking = 1;
                          });
                          getLocation();
                          BlocProvider.of<BookingBloc>(context).add(
                            ConfirmBookingEvent(
                              rideId: int.parse(widget.bookingId.toString()),
                            ),
                          );
                          debugPrint("accept and get positon");
                          // Logger().e(
                          //     "D+++++++: $currentLatDriver-$currentLngDriver = ${widget.latPassenger} - ${widget.lngPassenger}");
                          // _drawPolylines(
                          //     dLocation: LatLng(currentLatDriver, currentLngDriver),
                          //     pLocation: LatLng(widget.latPassenger, widget.lngPassenger));
                        },
                        color: AppColors.main,
                        textColor: AppColors.light4,
                        label: "Accept",
                        enableWidth: true,
                        width: MediaQuery.of(context).size.width / 2,
                        // enableWidth: false,
                      )
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

  Widget arrivedPassengerWidget(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        // height: isExpanded
        //     ? MediaQuery.of(context).size.height / 2.5 // Expanded height
        //     : MediaQuery.of(context).size.height / 3.5, // Collapsed height
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
          child: Column(
            children: [
              ExpansionTile(
                shape: const Border(),
                initiallyExpanded: true,
                title: Text(
                  "Navigate to Passenger",
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: AppColors.main,
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    isExpanded = expanded;
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  child: Image.network(widget.imagePassanger),
                                ),
                                const SizedBox(width: 18),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.namePassanger,
                                      style: AppTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
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
                            IconButton(
                              onPressed: () {
                                _launchLink("tel:${widget.phonePassanger}");
                              },
                              icon: const Icon(Icons.phone_outlined,
                                  color: AppColors.main),
                            ),
                          ],
                        ),
                        const Divider(thickness: .1, color: Colors.grey),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top location text
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Passenger Location",
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
                            widget.desLatPassenger != null &&
                                    widget.desLngPassenger != null
                                ? Column(crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Destination Location",
                                        style: AppTextStyles.bodyDark.copyWith(
                                          color: AppColors.dark3,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "${widget.desLatPassenger} - ${widget.desLngPassenger}",
                                        style: AppTextStyles.bodyDark.copyWith(
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
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                // color: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FBTNWidget(
                      onPressed: () {
                        showYesNoCustomDialog(context, "Cancel Booking",
                            "Are you sure you want to cancel this booking?",
                            onYes: () {
                          BlocProvider.of<BookingBloc>(context).add(
                            CanceBookingEvent(rideId: int.parse(widget.bookingId.toString())), // Example ID
                          );
                        });
                      },
                      color: AppColors.dark1,
                      textColor: AppColors.light4,
                      label: "Cancel",
                      enableWidth: true,
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                    FBTNWidget(
                      onPressed: () {
                        setState(() {
                          typeProcessBooking = 2;
                        });
                        getLocation();
                        BlocProvider.of<BookingBloc>(context).add(
                          ArrivedEvent(
                            rideId: int.parse(widget.bookingId),
                          ),
                        );
                      },
                      color: AppColors.main,
                      textColor: AppColors.light4,
                      label: "Arrived Passenger",
                      enableWidth: true,
                      width: MediaQuery.of(context).size.width / 2,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget startDriveWidget(BuildContext context) {
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
                    "Customer Location",
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
                      CircleAvatar(
                        radius: 24,
                        child: Image.network(widget.imagePassanger),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.namePassanger,
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top location text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Passenger Location",
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
                    widget.desLatPassenger != null &&
                            widget.desLngPassenger != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Destination Location",
                                style: AppTextStyles.bodyDark.copyWith(
                                  color: AppColors.dark3,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "${widget.desLatPassenger} - ${widget.desLngPassenger}",
                                style: AppTextStyles.bodyDark.copyWith(
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
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FBTNWidget(
                        onPressed: () {
                          showYesNoCustomDialog(context, "Cancel Booking",
                              "Are you sure you want to cancel this booking?",
                              onYes: () {
                            BlocProvider.of<BookingBloc>(context).add(
                              CanceBookingEvent(rideId: int.parse(widget.bookingId.toString())), // Example ID
                            );
                          });
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
                            setState(() {
                              typeProcessBooking = 3;
                            });
                            getLocation();
                            BlocProvider.of<BookingBloc>(context).add(
                              StartTripEvent(
                                rideId: int.parse(widget.bookingId),
                              ),
                            );
                          },
                          color: AppColors.main,
                          textColor: AppColors.light4,
                          label: "Start",
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
