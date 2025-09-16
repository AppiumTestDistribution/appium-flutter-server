import UIKit
import Flutter
import WebKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      if #available(iOS 16.4, *) {
          let webView = WKWebView(frame: .zero)
          webView.isInspectable = true
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
