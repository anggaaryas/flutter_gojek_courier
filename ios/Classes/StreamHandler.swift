//
//  StreamHandler.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 20/07/22.
//

import Foundation
import CourierCore
import Combine


class EventStreamHandler : NSObject, FlutterStreamHandler {

    
    private let courierClient: CourierClient
    
    init(courierClient: CourierClient) {
        self.courierClient = courierClient
    }
 
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        courierClient.addEventHandler(EventHandler(eventSink: events))
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        
        return nil
    }
  
}


@available(iOS 13.0, *)
class ReceiveDataHandler : NSObject, FlutterStreamHandler{
    typealias cAnyCancelable = Combine.AnyCancellable
    
    private let incomeingMessage: IncomingDataMessage
    private var cancelable: cAnyCancelable?
    
    init(incomingMessage: IncomingDataMessage) {
        self.incomeingMessage = incomingMessage
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        cancelable = incomeingMessage.objectWillChange.sink{ [self] _ in
            print(incomeingMessage.message)
            events("{\"topic\" : \"\(incomeingMessage.topic)\", \"data\": \(incomeingMessage.message)}")
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        cancelable?.cancel()
        return nil
    }
}
