//
//  StreamHandler.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 20/07/22.
//

import Foundation



class EventStreamHandler : NSObject, FlutterStreamHandler {
    
    var sink: FlutterEventSink?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        
        return nil
    }
  
}
