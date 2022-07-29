//
//  StreamHandler.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 20/07/22.
//

import Foundation
import CourierCore
import Combine


@available(iOS 13.0, *)
class EventStreamHandler : NSObject, FlutterStreamHandler {

    
    private let library: GojekCourierCore
    private var sink: FlutterEventSink?
    
    init(library: GojekCourierCore) {
        print("coba assign library event...")
        self.library  = library
    }
    
    func addEventaListener(){
        print("coba listen...")
        library.addEventListener(eventSink: sink!)
    }
 
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
  
}


@available(iOS 13.0, *)
class ReceiveDataHandler : NSObject, FlutterStreamHandler{

    private let library: GojekCourierCore
    private var sink: FlutterEventSink?
    
    init(library: GojekCourierCore) {
        self.library = library
    }
    
    func setReceiveDataSink(){
        if let sink = sink {
            library.setMessageSink(sink: sink)
        } else {
            print("Sink null")
            // Handle error...
        }
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
}
