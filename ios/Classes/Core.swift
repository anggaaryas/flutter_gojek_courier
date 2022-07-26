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
    private var cancellables = Set<AnyCancellable>()
    private var courierParam : CourierParam?
    let incomingMessage = IncomingDataMessage()
    
    func initCourier(courierParam: CourierParam){
        
        // simpan courier param nya dahulu. init nya pas mau connect karena
        // butuh auth (Connect Option)
        self.courierParam = courierParam
        
    }
    
    func connect(param: MqttConnectOptionParam){
        
        // setelah dapat connectOption nya, baru di init dahulu
        // dan coba connec
        let clientFactory = CourierClientFactory()
        let configAdapter = MqttClientConfigAdapter(mqttConfig: courierParam!.courierConfiguration!.client!.configuration!, connectOption: param)
        let mqttConfig = configAdapter.build()
        
        courierClient = clientFactory.makeMQTTClient(config: mqttConfig)
        courierClient?.connect()
        
        
    }
    
    func disconnect(){
        courierClient?.disconnect()
    }
    
    func subscribe(topic: String, qos: QoS){
        print("subscribe \(topic)")
        courierClient?.subscribe((topic, qos))
    }
    
    func unsubscribe(topic: String){
        courierClient?.unsubscribe(topic)
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
    
    func listen(topic:String){
        print("listen \(topic)")
        courierClient?.messagePublisher(topic: topic)
            .sink { [weak self] in
                self?.handleMessageReceiveEvent(.success($0), topic: topic)
            }.store(in: &cancellables)
    }
    
    private func handleMessageReceiveEvent(_ message: Result<Data, NSError>, topic: String) {
        switch message {
        case let .success(message):
            let msg = String(data: message, encoding: .utf8) ?? "Failed to decode message to string"
            incomingMessage.newMessage(message: msg, topic: topic)
            // kirim ke flutter
        case let .failure(error):
            print(error.localizedDescription)
        }
    }
}
