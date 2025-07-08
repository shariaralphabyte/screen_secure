import Flutter
import UIKit

public class ScreenSecurePlugin: NSObject, FlutterPlugin {
    private var secureView: UIView?
    private var isScreenshotBlocked = false
    private var isScreenRecordBlocked = false
    private var channel: FlutterMethodChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "screen_secure", binaryMessenger: registrar.messenger())
        let instance = ScreenSecurePlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            let args = call.arguments as? [String: Any]
            let screenshotBlock = args?["screenshotBlock"] as? Bool ?? true
            let screenRecordBlock = args?["screenRecordBlock"] as? Bool ?? true
            initScreenSecure(screenshotBlock: screenshotBlock, screenRecordBlock: screenRecordBlock, result: result)
        case "enableScreenshotBlock":
            enableScreenshotBlock(result: result)
        case "disableScreenshotBlock":
            disableScreenshotBlock(result: result)
        case "enableScreenRecordBlock":
            enableScreenRecordBlock(result: result)
        case "disableScreenRecordBlock":
            disableScreenRecordBlock(result: result)
        case "isScreenRecording":
            result(UIScreen.main.isCaptured)
        case "getSecurityStatus":
            getSecurityStatus(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func initScreenSecure(screenshotBlock: Bool, screenRecordBlock: Bool, result: @escaping FlutterResult) {
        if screenshotBlock {
            enableScreenshotProtection()
        }
        if screenRecordBlock {
            enableScreenRecordProtection()
        }
        result(true)
    }

    private func enableScreenshotBlock(result: @escaping FlutterResult) {
        enableScreenshotProtection()
        result(true)
    }

    private func disableScreenshotBlock(result: @escaping FlutterResult) {
        disableScreenshotProtection()
        result(true)
    }

    private func enableScreenRecordBlock(result: @escaping FlutterResult) {
        enableScreenRecordProtection()
        result(true)
    }

    private func disableScreenRecordBlock(result: @escaping FlutterResult) {
        disableScreenRecordProtection()
        result(true)
    }

    private func getSecurityStatus(result: @escaping FlutterResult) {
        let status: [String: Any] = [
            "screenshotBlocked": isScreenshotBlocked,
            "screenRecordBlocked": isScreenRecordBlocked,
            "platform": "ios",
            "isCurrentlyRecording": UIScreen.main.isCaptured
        ]
        result(status)
    }

    private func enableScreenshotProtection() {
        createSecureView()
        isScreenshotBlocked = true
    }

    private func disableScreenshotProtection() {
        removeSecureView()
        isScreenshotBlocked = false
    }

    private func enableScreenRecordProtection() {
        if #available(iOS 11.0, *) {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(screenCaptureChanged),
                name: UIScreen.capturedDidChangeNotification,
                object: nil
            )
        }
        isScreenRecordBlocked = true
    }

    private func disableScreenRecordProtection() {
        if #available(iOS 11.0, *) {
            NotificationCenter.default.removeObserver(
                self,
                name: UIScreen.capturedDidChangeNotification,
                object: nil
            )
        }
        isScreenRecordBlocked = false
    }

    private func createSecureView() {
        guard let window = UIApplication.shared.windows.first else { return }

        secureView = UIView(frame: window.bounds)
        secureView?.backgroundColor = UIColor.black
        secureView?.alpha = 0

        let warningLabel = UILabel()
        warningLabel.text = "🔐 Screen Recording Blocked"
        warningLabel.textColor = UIColor.white
        warningLabel.textAlignment = .center
        warningLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false

        secureView?.addSubview(warningLabel)
        window.addSubview(secureView!)

        NSLayoutConstraint.activate([
            warningLabel.centerXAnchor.constraint(equalTo: secureView!.centerXAnchor),
            warningLabel.centerYAnchor.constraint(equalTo: secureView!.centerYAnchor)
        ])
    }

    private func removeSecureView() {
        secureView?.removeFromSuperview()
        secureView = nil
    }

    @objc private func screenCaptureChanged() {
        if UIScreen.main.isCaptured {
            secureView?.alpha = 1
        } else {
            secureView?.alpha = 0
        }

        channel?.invokeMethod("onScreenRecordingChanged", arguments: UIScreen.main.isCaptured)
    }
}