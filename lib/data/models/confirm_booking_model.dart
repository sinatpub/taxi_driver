class ConfirmBookingModel {
  Data? data;
  bool? status;
  String? message;

  ConfirmBookingModel({
    this.data,
    this.status,
    this.message,
  });

  factory ConfirmBookingModel.fromJson(Map<String, dynamic> json) =>
      ConfirmBookingModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "status": status,
        "message": message,
      };
}

class Data {
  int? id;
  String? bookingCode;
  String? startLatitude;
  String? startLongitude;
  dynamic endLatitude;
  dynamic endLongitude;
  dynamic startTime;
  dynamic endTime;
  String? startAddress;
  dynamic endAddress;
  dynamic fare;
  int? status;
  String? statusName;
  Driver? passenger;
  Driver? driver;
  dynamic payment;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        passenger: json["passenger"] == null
            ? null
            : Driver.fromJson(json["passenger"]),
        driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
        payment: json["payment"],
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
        "start_time": startTime,
        "end_time": endTime,
        "start_address": startAddress,
        "end_address": endAddress,
        "fare": fare,
        "status": status,
        "status_name": statusName,
        "passenger": passenger?.toJson(),
        "driver": driver?.toJson(),
        "payment": payment,
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
  int? roleId;

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
    this.roleId,
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
        roleId: json["role_id"],
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
        vehicleImage: json["vehicle_image"] == null
            ? []
            : List<VehicleImage>.from(
                json["vehicle_image"]!.map((x) => VehicleImage.fromJson(x))),
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
