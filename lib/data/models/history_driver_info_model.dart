// To parse this JSON data, do
//
//     final historyDriveInfoModel = historyDriveInfoModelFromJson(jsonString);

import 'dart:convert';

HistoryDriveInfoModel historyDriveInfoModelFromJson(String str) => HistoryDriveInfoModel.fromJson(json.decode(str));

String historyDriveInfoModelToJson(HistoryDriveInfoModel data) => json.encode(data.toJson());

class HistoryDriveInfoModel {
    List<Datum>? data;
    int? currentPage;
    int? perPage;
    int? total;
    bool? status;
    String? message;

    HistoryDriveInfoModel({
        this.data,
        this.currentPage,
        this.perPage,
        this.total,
        this.status,
        this.message,
    });

    factory HistoryDriveInfoModel.fromJson(Map<String, dynamic> json) => HistoryDriveInfoModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        currentPage: json["current_page"],
        perPage: json["per_page"],
        total: json["total"],
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "current_page": currentPage,
        "per_page": perPage,
        "total": total,
        "status": status,
        "message": message,
    };
}

class Datum {
    int? id;
    String? bookingCode;
    String? startLatitude;
    String? startLongitude;
    dynamic endLatitude;
    dynamic endLongitude;
    dynamic startTime;
    dynamic endTime;
    dynamic startAddress;
    dynamic endAddress;
    dynamic fare;
    int? status;
    String? statusName;
    Passenger? passenger;
    Driver? driver;
    Payment? payment;
    String? createdAt;
    String? updatedAt;

    Datum({
        this.id,
        this.bookingCode,
        this.startLatitude,
        this.startLongitude,
        this.endLatitude,
        this.endLongitude,
        this.startTime,
        this.endTime,
        this.startAddress,
        this.endAddress,
        this.fare,
        this.status,
        this.statusName,
        this.passenger,
        this.driver,
        this.payment,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        bookingCode: json["booking_code"],
        startLatitude: json["start_latitude"],
        startLongitude: json["start_longitude"],
        endLatitude: json["end_latitude"],
        endLongitude: json["end_longitude"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        startAddress: json["start_address"],
        endAddress: json["end_address"],
        fare: json["fare"],
        status: json["status"],
        statusName: json["status_name"],
        passenger: json["passenger"] ==null?null:Passenger.fromJson(json["passenger"]),
        driver: json["driver"] == null?null:Driver.fromJson(json["driver"]),
        payment: json["payment"] == null?null:Payment.fromJson(json["payment"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "booking_code": bookingCode,
        "start_latitude": startLatitude,
        "start_longitude": startLongitude,
        "end_latitude": endLatitude,
        "end_longitude": endLongitude,
        "start_time": startTime,
        "end_time": endTime,
        "start_address": startAddress,
        "end_address": endAddress,
        "fare": fare,
        "status": status,
        "status_name": statusName,
        "passenger": passenger?.toJson(),
        "driver": driver?.toJson(),
        "payment": payment?.toJson(),
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class Driver {
    int? id;
    String? name;
    String? lastName;
    String? firstName;
    String? email;
    int? gender;
    String? dob;
    String? countryCode;
    String? phone;
    int? cardType;
    String? cardNumber;
    String? cardImage;
    String? driverLicenseNumber;
    String? driverLicenseExpired;
    String? driverLicenseImage;
    int? status;
    String? statusDate;
    String? profileImage;
    Vehicle? vehicle;
    LastLocation? lastLocation;

    Driver({
        this.id,
        this.name,
        this.lastName,
        this.firstName,
        this.email,
        this.gender,
        this.dob,
        this.countryCode,
        this.phone,
        this.cardType,
        this.cardNumber,
        this.cardImage,
        this.driverLicenseNumber,
        this.driverLicenseExpired,
        this.driverLicenseImage,
        this.status,
        this.statusDate,
        this.profileImage,
        this.vehicle,
        this.lastLocation,
    });

    factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        firstName: json["first_name"],
        email: json["email"],
        gender: json["gender"],
        dob: json["dob"],
        countryCode: json["country_code"],
        phone: json["phone"],
        cardType: json["card_type"],
        cardNumber: json["card_number"],
        cardImage: json["card_image"],
        driverLicenseNumber: json["driver_license_number"],
        driverLicenseExpired: json["driver_license_expired"],
        driverLicenseImage: json["driver_license_image"],
        status: json["status"],
        statusDate: json["status_date"],
        profileImage: json["profile_image"],
        vehicle: json["vehicle"] == null?null: Vehicle.fromJson(json["vehicle"]),
        lastLocation:json["last_location"] == null?null:LastLocation.fromJson(json["last_location"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "first_name": firstName,
        "email": email,
        "gender": gender,
        "dob": dob,
        "country_code": countryCode,
        "phone": phone,
        "card_type": cardType,
        "card_number": cardNumber,
        "card_image": cardImage,
        "driver_license_number": driverLicenseNumber,
        "driver_license_expired": driverLicenseExpired,
        "driver_license_image": driverLicenseImage,
        "status": status,
        "status_date": statusDate,
        "profile_image": profileImage,
        "vehicle": vehicle?.toJson(),
        "last_location": lastLocation?.toJson(),
    };
}

class LastLocation {
    String? latitude;
    String? longitude;

    LastLocation({
        this.latitude,
        this.longitude,
    });

    factory LastLocation.fromJson(Map<String, dynamic> json) => LastLocation(
        latitude: json["latitude"],
        longitude: json["longitude"],
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}

class Vehicle {
    int? id;
    int? typeVehicleId;
    String? model;
    String? manufacturer;
    int? yearOfManufacture;
    String? color;
    String? plateNumber;
    String? enginePower;
    int? maxPassenger;
    int? status;
    List<VehicleImage>? vehicleImage;

    Vehicle({
        this.id,
        this.typeVehicleId,
        this.model,
        this.manufacturer,
        this.yearOfManufacture,
        this.color,
        this.plateNumber,
        this.enginePower,
        this.maxPassenger,
        this.status,
        this.vehicleImage,
    });

    factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        typeVehicleId: json["type_vehicle_id"],
        model: json["model"],
        manufacturer: json["manufacturer"],
        yearOfManufacture: json["year_of_manufacture"],
        color: json["color"],
        plateNumber: json["plate_number"],
        enginePower: json["engine_power"],
        maxPassenger: json["max_passenger"],
        status: json["status"],
        vehicleImage: List<VehicleImage>.from(json["vehicle_image"].map((x) => VehicleImage.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type_vehicle_id": typeVehicleId,
        "model": model,
        "manufacturer": manufacturer,
        "year_of_manufacture": yearOfManufacture,
        "color": color,
        "plate_number": plateNumber,
        "engine_power": enginePower,
        "max_passenger": maxPassenger,
        "status": status,
        "vehicle_image": List<dynamic>.from(vehicleImage!.map((x) => x.toJson())),
    };
}

class VehicleImage {
    int? id;
    String? fileOriginalName;
    String? fileSize;
    String? fileType;
    String? fileUrl;
    int? objectId;
    String? objectType;
    dynamic createdBy;

    VehicleImage({
        this.id,
        this.fileOriginalName,
        this.fileSize,
        this.fileType,
        this.fileUrl,
        this.objectId,
        this.objectType,
        this.createdBy,
    });

    factory VehicleImage.fromJson(Map<String, dynamic> json) => VehicleImage(
        id: json["id"],
        fileOriginalName: json["file_original_name"],
        fileSize: json["file_size"],
        fileType: json["file_type"],
        fileUrl: json["file_url"],
        objectId: json["object_id"],
        objectType: json["object_type"],
        createdBy: json["created_by"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "file_original_name": fileOriginalName,
        "file_size": fileSize,
        "file_type": fileType,
        "file_url": fileUrl,
        "object_id": objectId,
        "object_type": objectType,
        "created_by": createdBy,
    };
}

class Passenger {
    int? id;
    String? name;
    String? lastName;
    String? firstName;
    String? email;
    int? gender;
    String? dob;
    String? countryCode;
    String? phone;
    dynamic cardType;
    dynamic cardNumber;
    dynamic cardImage;
    int? status;
    String? statusDate;
    int? roleId;
    String? profileImage;
    dynamic lastLocation;

    Passenger({
        this.id,
        this.name,
        this.lastName,
        this.firstName,
        this.email,
        this.gender,
        this.dob,
        this.countryCode,
        this.phone,
        this.cardType,
        this.cardNumber,
        this.cardImage,
        this.status,
        this.statusDate,
        this.roleId,
        this.profileImage,
        this.lastLocation,
    });

    factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        firstName: json["first_name"],
        email: json["email"],
        gender: json["gender"],
        dob: json["dob"],
        countryCode: json["country_code"],
        phone: json["phone"],
        cardType: json["card_type"],
        cardNumber: json["card_number"],
        cardImage: json["card_image"],
        status: json["status"],
        statusDate: json["status_date"],
        roleId: json["role_id"],
        profileImage: json["profile_image"],
        lastLocation: json["last_location"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "first_name": firstName,
        "email": email,
        "gender": gender,
        "dob": dob,
        "country_code": countryCode,
        "phone": phone,
        "card_type": cardType,
        "card_number": cardNumber,
        "card_image": cardImage,
        "status": status,
        "status_date": statusDate,
        "role_id": roleId,
        "profile_image": profileImage,
        "last_location": lastLocation,
    };
}

class Payment {
    int? id;
    int? invoiceId;
    int? rideId;
    String? distance;
    dynamic duration;
    String? amount;
    String? paymentMethod;
    int? status;
    String? statusName;
    String? createdAt;
    String? updatedAt;

    Payment({
        this.id,
        this.invoiceId,
        this.rideId,
        this.distance,
        this.duration,
        this.amount,
        this.paymentMethod,
        this.status,
        this.statusName,
        this.createdAt,
        this.updatedAt,
    });

    factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        invoiceId: json["invoice_id"],
        rideId: json["ride_id"],
        distance: json["distance"],
        duration: json["duration"],
        amount: json["amount"],
        paymentMethod: json["payment_method"],
        status: json["status"],
        statusName: json["status_name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_id": invoiceId,
        "ride_id": rideId,
        "distance": distance,
        "duration": duration,
        "amount": amount,
        "payment_method": paymentMethod,
        "status": status,
        "status_name": statusName,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
