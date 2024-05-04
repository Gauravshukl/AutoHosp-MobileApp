import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let CHANNEL = "com.example.flutter_firebase/wifi"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
        let wifiChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: flutterViewController.binaryMessenger)
        wifiChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "openWifiSettings" {
                self.openWifiSettings()
            } else {
                result(FlutterMethodNotImplemented)
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func openWifiSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
