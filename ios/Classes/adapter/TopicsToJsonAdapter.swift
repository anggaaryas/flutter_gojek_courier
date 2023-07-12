//
//  TopicsToJsonAdapter.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 08/03/23.
//

import Foundation
import CourierCore

class TopicsToJsonAdapter{
    
    let topics : [(topic: String, qos: QoS)]
    init(topics: [(topic: String, qos: QoS)]){
        self.topics = topics
    }
    
    func convert() -> String {
        var dict = Dictionary<String, QoS>(uniqueKeysWithValues: topics.map{ ($0, $1) })
    
        var temp = Dictionary<String, String>()
        for key in dict.keys{
            temp[key] = convertQosToString(qos: dict[key]!)
        }
        
        return temp.toJson()
    }
    
    func convertQosToString(qos: QoS) -> String {
        switch qos{
        case .zero:
            return "ZERO"
        case .one:
            return "ONE"
        case .two:
            return "TWO"
        case .oneWithoutPersistenceAndNoRetry:
            return "" // Currently not supported
        case .oneWithoutPersistenceAndRetry:
            return "" // Currently not supported
        }
    }
    
}
