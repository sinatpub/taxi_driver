import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

String convertTimeString(String input) {
  final hourRegex = RegExp(r'(\d+)\s*hour[s]?', caseSensitive: false);
  final minRegex = RegExp(r'(\d+)\s*min[s]?', caseSensitive: false);
  final secRegex = RegExp(r'(\d+)\s*secon[s]?',caseSensitive: false);

  final hourMatch = hourRegex.firstMatch(input);
  final minMatch = minRegex.firstMatch(input);
  final secMatch = secRegex.firstMatch(input);

  String hours = hourMatch != null ? hourMatch.group(1)! : '0';
  String minutes = minMatch != null ? minMatch.group(1)! : '0';
  String seconds = secMatch != null ? secMatch.group(1)! : '0';

  return '${hours == '0'?"":"$hours h"} ${minutes == '0'?"":"$minutes m"} ${hours == '0'|| minutes == '0'?"$seconds s" :""}';
}


String formatDateTime(String input) {
  final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  final dateTime = inputFormat.parse(input);

  final outputFormat = DateFormat("EEE/dd/MMM/yyyy hh:mm a");
  return outputFormat.format(dateTime);
}

String formatToTwoDecimalPlaces(String input) {
  double value = double.tryParse(input) ?? 0.0;
  String formatted = NumberFormat("#,##0.00").format(value);
  return formatted;
}

String formatDistanceWithUnits(String input, BuildContext context) {
  final String translate = context.locale.toString();
  final match = RegExp(r'^([0-9.]+)\s*(.*)$').firstMatch(input);
  if (match == null) return input;

  double number = double.tryParse(match.group(1) ?? '') ?? 0.0;
  String unit = match.group(2)?.toLowerCase() ?? '';

  return '${number.toStringAsFixed(2)} ${unit=="km"?translate == "km"?"គ.ម":unit :translate == "km"?"ម":unit}';
}

  // Future<String> getDrivingDistance(
  //     LatLng driver, LatLng destination, String apiKey) async {
  //   final url =
  //       "https://maps.googleapis.com/maps/api/directions/json?origin=${driver.latitude},${driver.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=$apiKey";

  //   final response = await get(Uri.parse(url));
  //   final data = jsonDecode(response.body);

  //   if (data["status"] == "OK") {
  //     var distance = data["routes"][0]["legs"][0]["distance"]["text"];
  //     var duration = data["routes"][0]["legs"][0]["duration"]["text"];
  //     print("Driving Distance: $distance");
  //     print("Estimated Time: $duration");
  //   } else {
  //     print("Error fetching distance: ${data['status']}");
  //   }
  // }