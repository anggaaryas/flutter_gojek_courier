//
//  IncomingMessage.swift
//  CourierCore
//
//  Created by Angga Arya Saputra on 26/07/22.
//

import Foundation

@available(iOS 13.0, *)
class IncomingDataMessage: ObservableObject{
    @Published var message : String = ""
    var topic: String = ""
    
    func newMessage(message: String, topic:String) {
        self.message = message
        self.topic = topic
    }
}
