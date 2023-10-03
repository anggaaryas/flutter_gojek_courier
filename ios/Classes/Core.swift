//
//  Core.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 14/07/22.
//

import Foundation
import CourierCore
import CourierMQTT

@available(iOS 13.0, *)
class GojekCourierCore{
    
    var courierClient: CourierClient?
    private var streamList = Dictionary<String, AnyCancellable>()
    private var globalListenSubscription : AnyCancellable?
    private var courierParam : CourierParam?
    
    var eventSink : FlutterEventSink?
    var messageSink : FlutterEventSink?
    var loggerSink : FlutterEventSink?
    
    
    func initCourierParam(courierParam: CourierParam){
        
        // simpan courier param nya dahulu. init nya pas mau connect karena
        // butuh auth (Connect Option)
        self.courierParam = courierParam
        
    }
    
    func initCourier(param: MqttConnectOptionParam){
        
        // setelah dapat connectOption nya, baru di init dahulu
        // dan coba connec
        let clientFactory = CourierClientFactory()
        let configAdapter = MqttClientConfigAdapter(mqttConfig: courierParam!.courierConfiguration!.client!.configuration!, connectOption: param)
        let mqttConfig = configAdapter.build()
        
        courierClient = clientFactory.makeMQTTClient(config: mqttConfig)
        globalListen()
    }
    
    func connect(){
        courierClient?.connect()
    }
    
    func addEventListener(eventSink : @escaping FlutterEventSink){
        self.eventSink = eventSink
        courierClient!.addEventHandler(self)
    }
    
    func disconnect(){
        courierClient?.disconnect()
        streamList.forEach { (key: String, value: AnyCancellable) in
            value.cancel()
        }
        streamList.removeAll()
        
    }
    
    func subscribe(topic: String, qos: QoS){
    
        courierClient?.subscribe((topic, qos))
    }
    
    func unsubscribe(topic: String){
        courierClient?.unsubscribe(topic)
        streamList[topic]?.cancel()
        streamList.removeValue(forKey: topic)
    }
    
    func send(topic:String, message:String, qos:QoS) throws{
        guard let data = message.data(using: .utf8) else {
            return
        }
        
        do {
            try courierClient?.publishMessage(data, topic: topic, qos: qos)
           
        } catch {
            throw error
        }
    }
    
    func sendByte(topic:String, message:Data, qos:QoS) throws{
        do {
            try courierClient?.publishMessage(message, topic: topic, qos: qos)
           
        } catch {
            throw error
        }
    }
    
    func setMessageSink(sink: @escaping FlutterEventSink){
        messageSink = sink
    }
    
    func setLoggerSink(sink: @escaping FlutterEventSink){
        loggerSink = sink
    }
    
    
    func globalListen(){
        globalListenSubscription = courierClient!.messagePublisher().sink{ [weak self] in
            self?.handleMessageReceiveEvent(.success($0.data), topic: $0.topic)}
    }
    
    @available(*, deprecated,  message: "use global listen")
    func listen(topic:String){
    
        let keyExists = streamList[topic] != nil
        if(!keyExists){
            streamList[topic] = courierClient!.messagePublisher(topic: topic)
                .sink { [weak self] in
                    
                    self?.handleMessageReceiveEvent(.success($0), topic: topic)
                }
        }
                
    }
    
    private func handleMessageReceiveEvent(_ message: Result<Data, NSError>, topic: String) {

        switch message {
        case let .success(message):
            let msg = [UInt8] (message)
            
            messageSink?("{\"topic\" : \"\(topic)\", \"data\": \(msg)}")
        case let .failure(error):
            print(error.localizedDescription)
        }
    }
}



