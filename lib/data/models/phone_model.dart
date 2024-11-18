
class PhoneNumberModel {
  Data data;
  bool status;
  String message;

  PhoneNumberModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory PhoneNumberModel.fromJson(Map<String, dynamic> json) =>
      PhoneNumberModel(
        data: Data.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
      };
}

class Data {
  int seconde;

  Data({
    required this.seconde,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        seconde: json["seconde"],
      );

  Map<String, dynamic> toJson() => {
        "seconde": seconde,
      };
}
