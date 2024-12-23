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
      _socket?.on(
        'newRide',
        (data) {
          tlog("Socket New Ride $data");
          // showNewRideAlert(data);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingScreen(
                bookingId: data["booking_code"],
                lat: data["location"]['latitude'],
                lng: data["location"]['longitude'],
                // desLat: data["destination"]['latitude'],
                // desLng: data["destination"]['longitude'],
                passengerId: data["passengerId"],
              ),
            ),
          );
        },
      );
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

  void acceptRide({
    required String driverId,
    required String bookingCode,
    required String passengerId,
    required double currentLat,
    required double currentLng,
    double? destinationLat,
    double? destinationLng,
  }) {
    _socket?.emit('acceptRide', {
      "driverId": "5", //driverId,
      "booking_code": "098765", // bookingCode,
      "passengerId": "6", //passengerId,
      "location": {
        "latitude": "$currentLat",
        "longitude": "$currentLng",
      },
      "destination": {
        "latitude": "$destinationLat",
        "longitude": "$destinationLng",
      }
    });
    tlog('Ride accepted with booking code: $bookingCode');
  }


  void newRide(context){
     _socket?.on(
      'newRide',
      (data) {
        tlog("Socket New Ride $data");
        showNewRideAlert(data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(
              bookingId: data["booking_code"],
              lat: data["location"]['latitude'],
              lng: data["location"]['longitude'],
              // desLat: data["destination"]['latitude'],
              // desLng: data["destination"]['longitude'],
              passengerId: data["passengerId"],
            ),
          ),
        );
      },
    );
  }

  @override
  void connectToSocket(String url, String driverId, String role,
      {required BuildContext context}) {
    super.connectToSocket(url, driverId, role, context: context);
    _socket?.on(
      'newRide',
      (data) {
        tlog("Socket New Ride $data");
        showNewRideAlert(data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(
              bookingId: data["booking_code"],
              lat: data["location"]['latitude'],
              lng: data["location"]['longitude'],
              // desLat: data["destination"]['latitude'],
              // desLng: data["destination"]['longitude'],
              passengerId: data["passengerId"],
            ),
          ),
        );
      },
    );
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

class PassengerSocketService extends BaseSocketService {
  @override
  void register(String passengerId) {
    _socket?.emit('registerPassenger', passengerId);
    tlog('Passenger registered with ID: $passengerId');
  }

  void requestRide({
    required String bookingCode,
    required String passengerId,
    required double startLat,
    required double startLng,
    required double destinationLat,
    required double destinationLng,
  }) {
    _socket?.emit('rideRequest', {
      "booking_code": bookingCode,
      "passengerId": passengerId,
      "location": {
        "latitude": startLat,
        "longitude": startLng,
      },
      "destination": {
        "latitude": destinationLat,
        "longitude": destinationLng,
      }
    });
    tlog('Ride requested with booking code: $bookingCode');
  }

  void handleRideAccepted(dynamic data) {
    // Implement the UI response or notification here
    tlog(
        'Ride accepted! Booking code: ${data["booking_code"]}, Driver ID: ${data["driverId"]}');
  }
}
