import 'package:flutter/services.dart';

Future<Uint8List> loadImageFromAssets(String assetPath) async {
  final ByteData byteData = await rootBundle.load(assetPath);
  return byteData.buffer.asUint8List();
}