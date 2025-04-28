enum ClientMethod { POST, GET, PATCH, DELETE }

class AppConstant {
  // Translate
  static const String khmerCode = "km";
  static const String englishCode = 'en';

  static const String titleApp = 'Hello World';

  // Based Url
  static const baseUrlApi = 'http://206.189.38.88:3007/'; // Dev

  // Socket IO Client
  static const socketBasedUrl = "http://206.189.38.88:3009/";

  static const driverId = "5";

  // Socket Event Client

  static const driverConnect = "driver_connect";

  static String? driverToken;
  // Custom Token
  static const String customeToken =
      '28|MTbCFQGmG4orNpm7GA0lVKPR4gopEjMHO8Zrq4iY';
  static const googleKeyApi = "AIzaSyAEZtLQKJGA-Phcfn339c2A5ppu9eh9lAY";

  // Image Placeholder
  static const imagePlaceholder =
      "https://www.unityhighschool.org/wp-content/uploads/2014/08/default-placeholder.png";

  /// Marker
  static const String driverMarker = "DriverMarkerId";

  // Padding Constant
  static const double padding01 = 6.0;
  static const double padding02 = 8.0;
  static const double padding03 = 12.0;
  static const double padding04 = 16.0;
  static const double padding05 = 18.0;
  static const double padding06 = 20.0;

  // Margin Constant
  static const double margin01 = 6.0;
  static const double margin02 = 8.0;
  static const double margin03 = 12.0;
  static const double margin04 = 16.0;
  static const double margin05 = 18.0;
  static const double margin06 = 20.0;
}
