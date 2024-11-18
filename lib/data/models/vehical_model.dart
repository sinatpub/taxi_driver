class VehicalTypeEntities {
  List<SingleVehical> data;
  String message;
  bool status;

  VehicalTypeEntities({
    required this.data,
    required this.message,
    required this.status,
  });

  factory VehicalTypeEntities.fromJson(Map<String, dynamic> json) =>
      VehicalTypeEntities(
        data: List<SingleVehical>.from(json["data"].map((x) => SingleVehical.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class SingleVehical {
  int id;
  String name;
  int price;
  String? image;
  DateTime createdAt;
  DateTime updatedAt;

  SingleVehical({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SingleVehical.fromJson(Map<String, dynamic> json) => SingleVehical(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
