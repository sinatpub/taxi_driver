class CurrentDriverInfoModel {
  DataDriverInfo? data;
  bool? status;
  String? message;

  CurrentDriverInfoModel({
    this.data,
    this.status,
    this.message,
  });

  factory CurrentDriverInfoModel.fromJson(Map<String, dynamic> json) =>
      CurrentDriverInfoModel(
        data: json["data"] == null ? null : DataDriverInfo.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "status": status,
        "message": message,
      };
}

class DataDriverInfo {
  int? id;
  String? bookingCode;
  String? startLatitude;
  String? startLongitude;
  dynamic endLatitude;
  dynamic endLongitude;
  DateTime? startTime;
  dynamic endTime;
  String? startAddress;
  dynamic endAddress;
  dynamic fare;
  int? status;
  String? statusName;
  Passenger? passenger;
  Driver? driver;
  Payment? payment;
  DateTime? createdAt;
  DateTime? updatedAt;

  DataDriverInfo({
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

  factory DataDriverInfo.fromJson(Map<String, dynamic> json) => DataDriverInfo(
        id: json["id"],
        bookingCode: json["booking_code"],
        startLatitude: json["start_latitude"],
        startLongitude: json["start_longitude"],
        endLatitude: json["end_latitude"],
        endLongitude: json["end_longitude"],
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        endTime: json["end_time"],
        startAddress: json["start_address"],
        endAddress: json["end_address"],
        fare: json["fare"],
        status: json["status"],
        statusName: json["status_name"],
        passenger: json["passenger"] == null
            ? null
            : Passenger.fromJson(json["passenger"]),
        driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
        payment: json["payment"] == null?null:Payment.fromJson(json["payment"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_code": bookingCode,
        "start_latitude": startLatitude,
        "start_longitude": startLongitude,
        "end_latitude": endLatitude,
        "end_longitude": endLongitude,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime,
        "start_address": startAddress,
        "end_address": endAddress,
        "fare": fare,
        "status": status,
        "status_name": statusName,
        "passenger": passenger?.toJson(),
        "driver": driver?.toJson(),
        "payment": payment?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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
        vehicle:
            json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
        lastLocation:json["last_location"] ==null?null:LastLocation.fromJson(json["last_location"]),
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
  int? roleId;
  LastLocation? lastLocation;

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
    this.driverLicenseNumber,
    this.driverLicenseExpired,
    this.driverLicenseImage,
    this.status,
    this.statusDate,
    this.profileImage,
    this.vehicle,
    this.roleId,
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
        driverLicenseNumber: json["driver_license_number"],
        driverLicenseExpired: json["driver_license_expired"],
        driverLicenseImage: json["driver_license_image"],
        status: json["status"],
        statusDate: json["status_date"],
        profileImage: json["profile_image"],
        vehicle:
            json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
        roleId: json["role_id"],
        lastLocation:json["last_location"] ==null?null:LastLocation.fromJson(json["last_location"]),
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
        "role_id": roleId,
        "last_location": lastLocation?.toJson(),
      };
}

class Vehicle {
  int? id;
  int? typeVehicleId;
  int? pricrVehicle;
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
    this.pricrVehicle,
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
        pricrVehicle: json["vehicle_price"] == null?null:json["vehicle_price"],
        model: json["model"],
        manufacturer: json["manufacturer"],
        yearOfManufacture: json["year_of_manufacture"],
        color: json["color"],
        plateNumber: json["plate_number"],
        enginePower: json["engine_power"],
        maxPassenger: json["max_passenger"],
        status: json["status"],
        vehicleImage: json["vehicle_image"] == null
            ? []
            : List<VehicleImage>.from(
                json["vehicle_image"]!.map((x) => VehicleImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_vehicle_id": typeVehicleId,
        "vehicle_price":pricrVehicle?? pricrVehicle,
        "model": model,
        "manufacturer": manufacturer,
        "year_of_manufacture": yearOfManufacture,
        "color": color,
        "plate_number": plateNumber,
        "engine_power": enginePower,
        "max_passenger": maxPassenger,
        "status": status,
        "vehicle_image": vehicleImage == null
            ? []
            : List<dynamic>.from(vehicleImage!.map((x) => x.toJson())),
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

class Payment {
    int? id;
    int? invoiceId;
    int? rideId;
    String? distance;
    String? duration;
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
