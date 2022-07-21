import Flutter
import UIKit

public class SwiftGojekCourierPlugin: NSObject, FlutterPlugin {
    
    let eventChannelName = "event_channel"
    let receiveDataChannel = "receive_data_channel"
    
    let eventStreamHandler = EventStreamHandler()
    
    let eventChannel : FlutterEventChannel?
    
    init(registrar : FlutterPluginRegistrar) {
        eventChannel =  FlutterEventChannel(name: eventChannelName, binaryMessenger: registrar.messenger())
        eventChannel!.setStreamHandler(eventStreamHandler)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "gojek_courier", binaryMessenger: registrar.messenger())
        let instance = SwiftGojekCourierPlugin(registrar: registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
}
