//
//  CourierParam.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 15/07/22.
//

import Foundation
import CourierCore
import CourierMQTT


class CourierParam: Param<CourierConfigurationParam>{
    var courierConfiguration : CourierConfigurationParam?
}


class CourierConfigurationParam {
    var client : MqttClientParam?
}

class MqttClientParam{
    var configuration: MqttConfigurationParam?
}

class MqttConfigurationParam{
    var connectRetryTimePolicy: ConnectRetryTimePolicyParam?
    var connectTimeoutPolicy: ConnectTimeoutPolicyParam?
    var subscriptionRetryPolicy: SubscriptionRetryPolicyParam?
    var unsubscriptionRetryPolicy: SubscriptionRetryPolicyParam?
    var wakeLockTimeout: Int?
    var pingSender: WorkManagerPingSenderConfigParam?
    var experimentConfig: ExperimentConfigParam?
    
}

class ExperimentConfigParam {
    var isPersistentSubscriptionStoreEnabled: Bool?
    var adaptiveKeepAliveConfig: AdaptiveKeepAliveConfigParam?
}

class AdaptiveKeepAliveConfigParam {
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
}

class WorkManagerPingSenderConfigParam {
    var timeoutSeconds: Int?
}

class SubscriptionRetryPolicyParam {
    var maxRetryCount: UInt16?
}

class ConnectTimeoutPolicyParam : Param<IConnectTimeoutPolicy> {
    var sslHandshakeTimeOut: TimeInterval?
    var sslUpperBoundConnTimeOut: TimeInterval?
    var upperBoundConnTimeOut: TimeInterval?
    
    override func build() -> IConnectTimeoutPolicy {
        let timeout = upperBoundConnTimeOut ?? sslHandshakeTimeOut ?? sslUpperBoundConnTimeOut ?? 10
        let timeInterval = 16.0
        return ConnectTimeoutPolicy(isEnabled: true, timerInterval: timeInterval, timeout: timeout)
    }
}

class ConnectRetryTimePolicyParam  {
    var maxRetryCount: Int?
    var reconnectTimeFixed: UInt16?
    var reconnectTimeRandom: Int?
    var maxReconnectTime: UInt16?
}
