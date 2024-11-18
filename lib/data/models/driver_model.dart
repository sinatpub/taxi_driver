import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Driver {
  int id;
  String bkId;
  String locale = 'km';
  LatLng? latLng;
  String? name;
  String? phone;
  String? pId;
  int? canRequest;
  int? travelStatus;
  int? status = 1;
  int? categoryId;
  String? categoryName;
  String? categoryIcon;
  String? avatar;
  int? checkLocation;
  dynamic rotation;

  Driver(
      {required this.id,
      required this.bkId,
      this.latLng,
      this.name,
      this.phone,
      this.pId,
      this.canRequest,
      this.categoryId,
      this.status,
      this.travelStatus,
      this.categoryIcon,
      this.avatar,
      this.categoryName,
      this.checkLocation,
      this.rotation});

  static Driver? fromPersist(SharedPreferences prefs) {
    String? data = prefs.getString('DRIVER-KEY');
    if (data != null) {
      final json = jsonDecode(data);
      if (json != null) {
        var driver = Driver(
            id: json['id'],
            bkId: json['bkId'],
            latLng: LatLng(json['latitude'], json['longitude']),
            name: json['name'],
            phone: json['phone'],
            pId: json['pid'],
            canRequest: json['can_request'],
            categoryId: json['category_id'],
            travelStatus: json['travel_status']);
        driver.locale = json['locale'] ?? driver.locale;
        driver.rotation = json['rotation'];
        return driver;
      }
    }
    return null;
  }

  Future<bool> toPersist(SharedPreferences prefs) async {
    bool persis = await prefs.setString(
        'DRIVER-KEY',
        jsonEncode({
          'id': id,
          'bkId': bkId,
          'latitude': latLng?.latitude ?? 0,
          'longitude': latLng?.longitude ?? 0,
          'name': name,
          'phone': phone,
          'pid': pId,
          'can_request': canRequest,
          'category_id': categoryId,
          'travel_status': travelStatus,
          'locale': locale,
          'rotation': rotation
        }));
    return persis;
  }

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
      id: json['id'],
      bkId: json['bk_id'],
      latLng: LatLng(double.parse((json['latitude'] ?? 0).toString()),
          double.parse((json['longitude'] ?? 0).toString())),
      phone: json['phone'],
      name: json['name'],
      pId: json['pid'],
      status: int.parse((json['status'] ?? 1).toString()),
      canRequest: int.parse(json['can_request'].toString()),
      categoryId: int.parse(json['category_id'].toString()),
      travelStatus: int.parse(json['travel_status'].toString()),
      categoryIcon: json['category_icon'],
      avatar: json['avatar'],
      rotation: json['rotation'],
      categoryName: json['category_name'],
      checkLocation: json['check_location'] ?? 1);

  factory Driver.signJson(Map<String, dynamic> json) => Driver(
      id: json['id'],
      bkId: json['bk_id'],
      phone: json['phone'],
      name: json['name'],
      pId: json['pid']);
}
