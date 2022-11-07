//
//  CourierParam.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 15/07/22.
//

import Foundation
import CourierCore
import CourierMQTT
import UIKit
import SwiftProtobuf


class CourierParam: Param{
    var courierConfiguration : CourierConfigurationParam?
    
    override init(value: Dictionary<String, Any?>) {
        super.init(value: value)
        setClassParam(value: value["configuration"] as Any?, onNotNull: { (param) in
            courierConfiguration = CourierConfigurationParam(value: param)
        })
    }
}


class CourierConfigurationParam: Param {
    var client : MqttClientParam?
    
    override init(value: Dictionary<String, Any?>) {
        super.init(value: value)
        setClassParam(value: value["client"] as Any?, onNotNull: { (param) in
            client = MqttClientParam(value: param)
        })
    }
}

class MqttClientParam: Param{
    var configuration: MqttConfigurationParam?
    
    override init(value: Dictionary<String, Any?>) {
        super.init(value: value)
        setClassParam(value: value["configuration"] as Any?, onNotNull: { (param) in
            configuration = MqttConfigurationParam(value: param )
        })
    }
}

class MqttConfigurationParam: Param{
    var connectRetryTimePolicy: ConnectRetryTimePolicyParam?
    var connectTimeoutPolicy: ConnectTimeoutPolicyParam?
    var subscriptionRetryPolicy: SubscriptionRetryPolicyParam?
    var unsubscriptionRetryPolicy: SubscriptionRetryPolicyParam?
    var wakeLockTimeout: Int?
    var pingSender: WorkManagerPingSenderConfigParam?
    var experimentConfig: ExperimentConfigParam?
    
    override init(value: Dictionary<String, Any?>) {
        super.init(value: value)
        setClassParam(value: value["connectRetryTimePolicy"] as Any?, onNotNull: { (param) in
            connectRetryTimePolicy = ConnectRetryTimePolicyParam(value: param )
        })
        setClassParam(value: value["connectTimeoutPolicy"] as Any?, onNotNull: { (param) in
            connectTimeoutPolicy = ConnectTimeoutPolicyParam(value: param )
        })
        setClassParam(value: value["subscriptionRetryPolicy"] as Any?, onNotNull: { (param) in
            subscriptionRetryPolicy = SubscriptionRetryPolicyParam(value: param )
        })
        setClassParam(value: value["unsubscriptionRetryPolicy"] as Any?, onNotNull: { (param) in
            unsubscriptionRetryPolicy = SubscriptionRetryPolicyParam(value: param )
        })
        setClassParam(value: value["pingSender"] as Any?, onNotNull: { (param) in
            pingSender = WorkManagerPingSenderConfigParam(value: param )
        })
        setClassParam(value: value["experimentConfig"] as Any?, onNotNull: { (param) in
            experimentConfig = ExperimentConfigParam(value: param )
        })
        setBasicParam(value: value["wakeLockTimeout"] as Any?, onNotNull: { (param: Int) in
            wakeLockTimeout = param
        })
    }
    
}

class ExperimentConfigParam: Param {
    var isPersistentSubscriptionStoreEnabled: Bool?
    var adaptiveKeepAliveConfig: AdaptiveKeepAliveConfigParam?
    
    override init(value: Dictionary<String, Any?>) {
        super.init(value: value)
        setClassParam(value: value["adaptiveKeepAliveConfig"] as Any?, onNotNull: {(param) in
            adaptiveKeepAliveConfig = AdaptiveKeepAliveConfigParam(value: param)
        })
        setBasicParam(value: value["isPersistentSubscriptionStoreEnabled"] as Any?, onNotNull: {(param: Bool) in
            isPersistentSubscriptionStoreEnabled = param
        })
    }
}

class AdaptiveKeepAliveConfigParam: Param {
    var lowerBoundMinutes: Int?
    var upperBoundMinutes: Int?
    var stepMinutes: Int?
    var optimalKeepAliveResetLimit : Int?
    var pingSender: WorkManagerPingSenderConfigParam?
    var activityCheckIntervalSeconds : TimeInterval?
    var inactivityTimeoutSeconds : TimeInterval?
    var policyResetTimeSeconds : Int?
    var incomingMessagesTTLSecs : TimeInterval?
    var incomingMessagesCleanupIntervalSecs : TimeInterval?
    
    override init(value: Dictionary<String, Any?>) {
        super.init(value: value)
        setBasicParam(value: value["lowerBoundMinutes"] as Any?, onNotNull: {(param: Int) in
            lowerBoundMinutes = param
        })
        setBasicParam(value: value["upperBoundMinutes"] as Any?, onNotNull: {(param: Int) in
            upperBoundMinutes = param
        })
        setBasicParam(value: value["stepMinutes"] as Any?, onNotNull: {(param: Int) in
            stepMinutes = param
        })
        setBasicParam(value: value["optimalKeepAliveResetLimit"] as Any?, onNotNull: {(param: Int) in
            optimalKeepAliveResetLimit = param
        })
        setBasicParam(value: value["activityCheckIntervalSeconds"] as Any?, onNotNull: {(param : TimeInterval) in
            activityCheckIntervalSeconds = param
        })
        setClassParam(value: value["pingSender"] as Any?, onNotNull: {(param) in
            pingSender = WorkManagerPingSenderConfigParam(value: param)
        })
        setBasicParam(value: value["inactivityTimeoutSeconds"] as Any?, onNotNull: {(param: TimeInterval) in
            inactivityTimeoutSeconds = param
        })
        setBasicParam(value: value["policyResetTimeSeconds"] as Any?, onNotNull: {(param: Int) in
            policyResetTimeSeconds = param
        })
        setBasicParam(value: value["incomingMessagesTTLSecs"] as Any?, onNotNull: {(param : TimeInterval) in
            incomingMessagesTTLSecs = param
        })
        setBasicParam(value: value["incomingMessagesCleanupIntervalSecs"] as Any?, onNotNull: {(param: TimeInterval) in
            incomingMessagesCleanupIntervalSecs = param
        })
        
    }
}

class WorkManagerPingSenderConfigParam: Param {
    var timeoutSeconds: Int?
    
    override init(value: Dictionary<String, Any?>) {
        super.init(value: value)
        setBasicParam(value: value["timeoutSeconds"] as Any?, onNotNull: {(param : Int) in
            timeoutSeconds = param
        })
    }
}

class SubscriptionRetryPolicyParam: Param {
    var maxRetryCount: UInt16?
    
    override init(value: Dictionary<String, Any?>) {
        super.init(value: value)
        setBasicParam(value: value["maxRetryCount"] as Any?, onNotNull: {(param : UInt16) in
            maxRetryCount = param
        })
    }
}

class ConnectTimeoutPolicyParam : Param {
    var sslHandshakeTimeOut: TimeInterval?
    var sslUpperBoundConnTimeOut: TimeInterval?
    var upperBoundConnTimeOut: TimeInterval?
    
    override init(value: Dictionary<String, Any?>) {
        super.init(value: value)
        setBasicParam(value: value["sslHandshakeTimeOut"] as Any?, onNotNull: {(param : TimeInterval) in
            sslHandshakeTimeOut = param
        })
        setBasicParam(value: value["sslUpperBoundConnTimeOut"] as Any?, onNotNull: {(param : TimeInterval) in
            sslUpperBoundConnTimeOut = param
        })
        setBasicParam(value: value["upperBoundConnTimeOut"] as Any?, onNotNull: {(param : TimeInterval) in
            upperBoundConnTimeOut = param
        })
    }
}

class ConnectRetryTimePolicyParam: Param {
    var maxRetryCount: Int?
    var reconnectTimeFixed: UInt16?
    var reconnectTimeRandom: Int?
    var maxReconnectTime: UInt16?
    
    override init(value: Dictionary<String, Any?>) {
        super.init(value: value)
        setBasicParam(value: value["maxRetryCount"] as Any?, onNotNull: {(param : Int) in
            maxRetryCount = param
        })
        setBasicParam(value: value["reconnectTimeFixed"] as Any?, onNotNull: {(param : UInt16) in
            reconnectTimeFixed = param
        })
        setBasicParam(value: value["reconnectTimeRandom"] as Any?, onNotNull: {(param : Int) in
            reconnectTimeRandom = param
        })
        setBasicParam(value: value["maxReconnectTime"] as Any?, onNotNull: {(param : UInt16) in
            maxReconnectTime = param
        })
    }
}
