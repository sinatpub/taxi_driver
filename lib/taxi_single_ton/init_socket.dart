import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/presentation/screens/booking/booking/booking_screen.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
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
  @override
  void register(String driverId) {
    _socket?.emit('registerDriver', driverId);
    tlog('Driver registered with ID: $driverId');
  }

  @override
  void connectToSocket(String url, String passengerId, String role,
      {required BuildContext context}) {
    super.connectToSocket("http://206.189.38.88:3009/", passengerId, role,
        context: context);
    newRide(context);
  }

  // * Listener
  void newRide(context) {
    _socket?.on(
      'newRide',
      (data) {
        tlog("Socket New Ride $data");
        // showNewRideAlert(data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(
             bookingId: data["booking_id"].toString(),
              lat: data["location"]['latitude'],
              lng: data["location"]['longitude'],
              // desLat: data["destination"]['latitude'],
              // desLng: data["destination"]['longitude'],
              passengerId: data["passenger_id"].toString(),
            ),
          ),
        );
      },
    );
  }


//   emit event rideArrival with parameter {
//     "booking_code": "xxxx",
//     "passengerId": "xxxx",
//     "location": {
//         "latitude": 12.9715987,
//         "longitude": 77.594566
//     },
//     "destination": {
//         "latitude": 12.927923,
//         "longitude": 77.627108
//     }
// }


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
      "passenger_id": passengerId,
    });
    tlog('Payment done' );
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
      "booking_code":bookingId,
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
    tlog('Ride accepted with booking code: $bookingId - $driverId - $passengerId - $currentLat - $currentLng - $destinationLat - $destinationLng');
  }

  void showNewRideAlert(dynamic data, {String? lat, String? lng}) {
    Taxi.shared.showNotification(
        driverId: lat ?? "",
        // ?? data['passengerId']??"123",
        bookingCode: lng ?? ""
        // ?? data['booking_code']??"123",
        );
  }
}
