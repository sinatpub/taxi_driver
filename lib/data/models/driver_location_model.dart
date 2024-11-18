
class UpdateDriverLocationModel {
  Data? data;
  bool? status;
  String? message;

  UpdateDriverLocationModel({
    this.data,
    this.status,
    this.message,
  });

  factory UpdateDriverLocationModel.fromJson(Map<String, dynamic> json) =>
      UpdateDriverLocationModel(
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
  String? latitude;
  String? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.userId,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
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
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
