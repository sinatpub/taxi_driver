import 'package:tara_driver_application/core/utils/app_constant.dart';
import 'package:tara_driver_application/core/utils/pretty_logger.dart';
import 'package:tara_driver_application/presentation/screens/booking/booking/booking_screen.dart';
import 'package:tara_driver_application/services/navigation_service.dart';
import 'package:tara_driver_application/taxi_single_ton/taxi.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class BaseSocketService {
  IO.Socket? _socket;

  void connectToSocket(String url, String id, String role,
      {required BuildContext context}) {
    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket?.onConnect((_) {
      tlog('$role connected to socket');
      register(id);
    });

    _socket?.onConnectError((err) {
      tlog('Connection Error: $err');
    });

    _socket?.onDisconnect((_) {
      tlog('$role socket disconnected');
    });
  }

  void register(String id);

  void disconnectSocket() {
    _socket?.disconnect();
    _socket = null;
  }
}

class DriverSocketService extends BaseSocketService {
  static final DriverSocketService _instance = DriverSocketService._internal();

  factory DriverSocketService() {
    return _instance;
  }

  DriverSocketService._internal();
  @override
  void register(String driverId) {
    _socket?.emit('registerDriver', driverId);
    tlog('Driver registered with ID: $driverId');
  }

  @override
  void connectToSocket(String url, String passengerId, String role,
      {required BuildContext context}) {
    super.connectToSocket(AppConstant.socketBasedUrl, passengerId, role,
        context: context);
    newRide(context);
  }

  // * Listener
  void newRide(context) {
    _socket?.off('newRide');
    _socket?.on(
      'newRide',
      (data) {
        tlog("Socket New Ride $data");

        Taxi.shared.notifyBooking(
            title: "NEWREQUEST".tr(),
            description: "DESREQUEST".tr(),
            isSound: true);


        // ! Why call this bloc when new request booking???
        // BlocProvider.of<CurrentDriverInfoBloc>(context)
        //     .add(GetCurrentInfoEvent());

        try {
          NavigationService().navigateTo(
            BookingScreen(
              typeVehicleId: 1,
              pricrVehicle: 1200,
              namePassanger: data["passenger"]["name"],
              phonePassanger: data["passenger"]["phone"],
              imagePassanger: data["passenger"]["profile"],
              timeOut: data["timeout"],
              processStepBook: 1,
              bookingCode: data["booking_code"].toString(),
              bookingId: data["booking_id"].toString(),
              latPassenger: data["location"]['latitude'],
              lngPassenger: data["location"]['longitude'],
              desLatPassenger: data["destination"]['latitude'],
              desLngPassenger: data["destination"]['longitude'],
              passengerId: data["passengerId"].toString(),
            ),
          );
        } catch (e) {
          tlog("Navigation failed: $e");
        }

      },
    );
  }

  void arrivedSocket() {
    _socket?.emit('rideArrival', {
      "isArrive": true,
    });
    tlog('Start ride with booking code:');
  }

  // * Listener
  void startDrive({
    required String driverId,
    required String bookingCode,
    required String passengerId,
    required double currentLat,
    required double currentLng,
    double? destinationLat,
    double? destinationLng,
  }) {
    _socket?.emit('startDrive', {
      "driverId": driverId,
      "booking_code": bookingCode,
      "passengerId": passengerId,
      "location": {
        "latitude": "$currentLat",
        "longitude": "$currentLng",
      },
      "destination": {
        "latitude": "$destinationLat",
        "longitude": "$destinationLng",
      }
    });
    tlog('Start ride with booking code: $bookingCode');
  }

  void dropDrive({
    required String driverId,
    required String bookingCode,
    required String passengerId,
    required double currentLat,
    required double currentLng,
    double? destinationLat,
    double? destinationLng,
  }) {
    _socket?.emit('dropDrive', {
      "driverId": driverId,
      "booking_code": bookingCode,
      "passengerId": passengerId,
      "location": {
        "latitude": "$currentLat",
        "longitude": "$currentLng",
      },
      "destination": {
        "latitude": "$destinationLat",
        "longitude": "$destinationLng",
      }
    });
    tlog('Start ride with booking code: $bookingCode');
  }

  void acceptPayment({required String passengerId}) {
    _socket?.emit('acceptPayment', {
      "passengerId": passengerId,
    });
    tlog('Payment done');
  }

  void acceptRide({
    required String driverId,
    required String bookingId,
    required String passengerId,
    required double currentLat,
    required double currentLng,
    double? destinationLat,
    double? destinationLng,
  }) {
    _socket?.emit('acceptRide', {
      "driverId": driverId,
      "booking_code": bookingId,
      "passengerId": passengerId,
      "location": {
        "latitude": "$currentLat",
        "longitude": "$currentLng",
      },
      "destination": {
        "latitude": "$destinationLat",
        "longitude": "$destinationLng",
      }
    });
    tlog(
        'Ride accepted with booking code: $bookingId - $driverId - $passengerId - $currentLat - $currentLng - $destinationLat - $destinationLng');
  }
}
