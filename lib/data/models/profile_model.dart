class ProfileModel {
  Data? data;
  bool? status;
  String? message;

  ProfileModel({
    this.data,
    this.status,
    this.message,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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

  Data({
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
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
