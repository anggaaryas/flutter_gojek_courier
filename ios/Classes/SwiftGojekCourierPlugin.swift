import Flutter
import UIKit

@available(iOS 13.0, *)
public class SwiftGojekCourierPlugin: NSObject, FlutterPlugin {
    
    let eventChannelName = "event_channel"
    let receiveDataChannelName = "receive_data_channel"
    
    var eventStreamHandler : EventStreamHandler?
    var receiveDataHandler: ReceiveDataHandler?
    
    let eventChannel : FlutterEventChannel?
    let receiveDataChannel : FlutterEventChannel?
    
    var core = GojekCourierCore()
    
    init(registrar : FlutterPluginRegistrar) {
        eventChannel =  FlutterEventChannel(name: eventChannelName, binaryMessenger: registrar.messenger())
        receiveDataChannel =  FlutterEventChannel(name: receiveDataChannelName, binaryMessenger: registrar.messenger())
        
        eventStreamHandler = EventStreamHandler(library: core)
        eventChannel!.setStreamHandler(eventStreamHandler)
        receiveDataHandler = ReceiveDataHandler(library: core)
        receiveDataChannel?.setStreamHandler(receiveDataHandler)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "gojek_courier", binaryMessenger: registrar.messenger())
        let instance = SwiftGojekCourierPlugin(registrar: registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method{
        case "initialise" :
            let param = call.arguments as? Dictionary<String, Any>
            let courierParam = CourierParam(value: param ?? [:])
            core.initCourierParam(courierParam: courierParam)
            result("")
            
        case "connect":
            let param = call.arguments as? Dictionary<String, Any>
            let connectParam = MqttConnectOptionParam(value: param ?? [:])
            core.initCourier(param: connectParam)
            eventStreamHandler!.addEventaListener()
            core.connect()
            
            
            result("")
            
        case "disconnect":
            core.disconnect()
            result("")
            
        case "subscribe":
            let param = call.arguments as? Dictionary<String, Any>
            let qos = QosParam(value: param!["qos"] as! String).build()
            let topic = param!["topic"] as! String
            core.subscribe(topic: topic, qos: qos)
            if core.messageSink == nil {
                receiveDataHandler?.setReceiveDataSink()
            }
            core.listen(topic: topic)
            result("")
            
        case "unsubscribe":
            let param = call.arguments as? Dictionary<String, Any>
            let topic = param!["topic"] as! String
            core.unsubscribe(topic: topic)
            result("")
            
        case "send":
            let param = call.arguments as? Dictionary<String, Any>
            let topic = param!["topic"] as! String
            let msg = param!["msg"] as! String
            let qos = QosParam(value: param!["qos"] as! String).build()
            do{
                try core.send(topic: topic, message: msg, qos: qos)
            } catch {
                print(error)
            }
            result("")
            
        case "sendByte":
            let param = call.arguments as? Dictionary<String, Any>
            let topic = param!["topic"] as! String
            let msg = param!["msg"] as! FlutterStandardTypedData
            let qos = QosParam(value: param!["qos"] as! String).build()
            do{
                try core.sendByte(topic: topic, message: msg.data, qos: qos)
            } catch {
                print(error)
            }
            result("")
            
        default:
            print(call.method)
        }
    }
}
