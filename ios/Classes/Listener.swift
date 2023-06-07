//
//  Listener.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 20/07/22.
//

import Foundation
import CourierCore

@available(iOS 13.0, *)
extension GojekCourierCore : ICourierEventHandler{
        func onEvent(_ event: CourierEvent) {
            let result = event.associatedValue()
            eventSink!(result)
        }
}


enum ResponseType{
    case VERBOSE
    case INFO
    case DEBUG
    case WARNING
    case ERROR
    case EVENT
}

func sendToFlutter(type: ResponseType, tag: String, msg: String, sink: FlutterEventSink?) {
        var typeString = ""
     
        switch (type){
            case .VERBOSE : typeString = "verbose"
            case .INFO : typeString = "info"
            case .DEBUG : typeString = "debug"
            case .WARNING : typeString = "warning"
            case .ERROR : typeString = "error"
            case .EVENT : typeString = "event"
        }
      
        sink?("{\"topic\" : \"\(tag)\", \"type\" : \"\(typeString)\", \"data\": \"\(msg)\"}")
}



extension CourierEvent{
    
    private func toString(topic: String, data: String) -> String {
        return "{\"type\" : \"event\" , \"topic\": \"\(topic)\", \"data\": \(data)}"
    }
    
    private func errorToString(error: Error?) -> String{
        if let error = error {
            return "{\"reasonCode\" : \((error as NSError).code), \"message\" : \"\((error as NSError).description.replacingOccurrences(of: "\"", with: ""))\"}"
        } else {
            return "{\"reasonCode\" : -1, \"message\" : \"-\"}"
        }
    }
    
    func associatedValue() -> String {
        switch self.type {

      case .connectionServiceAuthStart:
          return toString(topic: "Event$AuthenticatorAttemptEvent", data: "{}")  // ! different data from android
        case .connectionServiceAuthSuccess(timeTaken: _):
          return toString(topic: "Event$AuthenticatorSuccessEvent", data: "{}")
        case .connectionServiceAuthFailure(timeTaken: _, error: let error):
          return toString(topic: "Event$AuthenticatorErrorEvent", data: "\"exception\" : \(errorToString(error: error))")
      case .connectedPacketSent:
          return toString(topic: "Event$ConnectPacketSendEvent", data: "{}")
      case .courierDisconnect(clearState: let clearState):
          return toString(topic: "Event$CourierDisconnect", data: "{\"clearState\" : \(clearState)}")
      case .connectionAttempt:
          return toString(topic: "Event$MqttConnectAttemptEvent", data: "{}")
      case .connectionSuccess:
          return toString(topic: "Event$MqttConnectSuccessEvent", data: "{}")
        case .connectionFailure(timeTaken: _, error: let error):
          return toString(topic: "Event$MqttConnectFailureEvent", data: "{\"exception\" : \(errorToString(error: error))}")
        case .connectionLost(timeTaken: _, error: let error, diffLastInbound: let diffLastInbound, diffLastOutbound: let diffLastOutbound):
          let sessionMillis = (diffLastOutbound ?? 0) - (diffLastInbound ?? 0)
          return toString(topic: "Event$MqttConnectionLostEvent", data: "{\"exception\" : \(errorToString(error: error)), \"sessionTimeMillis\" : \(sessionMillis)}")
      case .connectionDisconnect:
          return toString(topic: "Event$MqttDisconnectCompleteEvent", data: "{}")
      case .reconnect:
          return toString(topic: "Event$MqttReconnectEvent", data: "{}")
      case .connectDiscarded(reason: let reason):
          return toString(topic: "Event$MqttConnectDiscardedEvent", data: "{\"reason\" : \"\(reason)\"}")
      case .subscribeAttempt(topics: let topics):
            return toString(topic: "Event$MqttSubscribeAttemptEvent", data: "{\"topics\" : \(Dictionary<String, Any?>(uniqueKeysWithValues: topics.map{ ($0, nil) }).toJson())}")
      case .unsubscribeAttempt(topics: let topics):
            return toString(topic: "Event$MqttUnsubscribeAttemptEvent", data: "{\"topics\" : \(topics.description)}")
      case .subscribeSuccess(topics: let topics, timeTaken: _):
            return toString(topic: "Event$MqttSubscribeSuccessEvent", data: "{\"topics\" : \(TopicsToJsonAdapter(topics: topics).convert())}")
      case .unsubscribeSuccess(topics: let topics, timeTaken: _):
            return toString(topic: "Event$MqttUnsubscribeSuccessEvent", data: "{\"topics\" : \(topics.description)}")
        case .subscribeFailure(topics: let topics, timeTaken: _, error: let error):
          return toString(topic: "Event$MqttSubscribeFailureEvent", data: "{\"exception\" : \(errorToString(error: error)), \"topics\" : \(TopicsToJsonAdapter(topics: topics).convert())}")
        case .unsubscribeFailure(topics: let topics, timeTaken: _, error: let error):
            return toString(topic: "Event$MqttUnsubscribeFailureEvent", data: "{\"exception\" : \(errorToString(error: error)), \"topics\" : \(topics.description)}")
      case .ping(url: let url):
          return toString(topic: "Event$MqttPingInitiatedEvent", data: "{\"serverUri\" : \"\(url)\"}")
      case .pongReceived(timeTaken: let timeTaken):
          return toString(topic: "Event$MqttPingSuccessEvent", data: "{\"timeTakenMillis\" : \(timeTaken)}")
      case .pingFailure(timeTaken: let timeTaken, error: let error):
          return toString(topic: "Event$MqttPingFailureEvent", data: "{\"timeTakenMillis\" : \(timeTaken) , \"exception\" : \(errorToString(error: error))}")
      case .messageReceive(topic: let topic, sizeBytes: let sizeBytes):
          return toString(topic: "Event$MqttMessageReceiveEvent", data: "{\"topic\" : \"\(topic)\", \"sizeBytes\" : \(sizeBytes)}")
      case .messageReceiveFailure(topic: let topic, error: let error, sizeBytes: let sizeBytes):
          return toString(topic: "Event$MqttMessageReceiveErrorEvent", data: "{\"topic\" : \"\(topic)\", \"sizeBytes\" : \(sizeBytes), \"exception\" : \(errorToString(error: error))}")
      case .messageSend(topic: let topic, qos: let qos, sizeBytes: let sizeBytes):
            return toString(topic: "Event$MqttMessageSendEvent", data: "{\"topic\" : \"\(topic)\", \"qos\" : \(qos.rawValue), \"sizeBytes\" : \(sizeBytes)}")
      case .messageSendSuccess(topic: let topic, qos: let qos, sizeBytes: let sizeBytes):
            return toString(topic: "Event$MqttMessageSendSuccessEvent", data: "{\"topic\" : \"\(topic)\", \"qos\" : \(qos.rawValue), \"sizeBytes\" : \(sizeBytes)}")
      case .messageSendFailure(topic: let topic, qos: let qos, error: let error, sizeBytes: let sizeBytes):
            return toString(topic: "Event$MqttMessageSendFailureEvent", data: "{\"topic\" : \"\(topic)\", \"qos\" : \(qos.rawValue), \"sizeBytes\" : \(sizeBytes), \"exception\" : \(errorToString(error: error))}")
      case .appForeground:
          return toString(topic: "Event$AppForegroundEvent", data: "{}")
      case .appBackground:
          return toString(topic: "Event$AppBackground", data: "{}")
      case .connectionAvailable:
          return toString(topic: "Event$ConnectionAvailable", data: "{}")
      case .connectionUnavailable:
          return toString(topic: "Event$ConnectionUnavailable", data: "{}")
      }
    }
}


extension Dictionary {

    func toJson() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self)
        else {
            return ""
        }
        if let string = String(data: data, encoding: .utf8) {
            return string
        } else {
            return ""
        }
    }
}
