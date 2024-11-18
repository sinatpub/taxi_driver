import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    GMSServices.provideAPIKey("AIzaSyAEZtLQKJGA-Phcfn339c2A5ppu9eh9lAY")
    GeneratedPluginRegistrant.register(with: self)

        // Set up the method channel
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let settingsChannel = FlutterMethodChannel(name: "com.com.tara_driver_application/settings",
                                                   binaryMessenger: controller.binaryMessenger)
        
        settingsChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if (call.method == "openAppSettings") {
                // Open the app settings
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        result(nil) // Indicate success
                    } else {
                        result(FlutterError(code: "UNAVAILABLE", message: "Settings cannot be opened", details: nil))
                    }
                } else {
                    result(FlutterError(code: "INVALID_URL", message: "Invalid settings URL", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
