class SetDriverStatusModel {
  Data? data;
  bool? status;
  String? message;

  SetDriverStatusModel({
    this.data,
    this.status,
    this.message,
  });

  factory SetDriverStatusModel.fromJson(Map<String, dynamic> json) =>
      SetDriverStatusModel(
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
  int? userId;
  int? vehicleId;
  String? licenseNumber;
  int? rating;
  int? isAvailable;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.userId,
    this.vehicleId,
    this.licenseNumber,
    this.rating,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        vehicleId: json["vehicle_id"],
        licenseNumber: json["license_number"],
        rating: json["rating"],
        isAvailable: json["is_available"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "vehicle_id": vehicleId,
        "license_number": licenseNumber,
        "rating": rating,
        "is_available": isAvailable,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
