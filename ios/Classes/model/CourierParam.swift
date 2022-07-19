//
//  CourierParam.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 15/07/22.
//

import Foundation
import CourierCore
import CourierMQTT


class CourierParam : Param<CourierClient>{
    var courierConfiguration : CourierConfigurationParam?
    
    override func build() -> CourierClient? {
        if(courierConfiguration != nil) {
            return CourierClientFactory().makeMQTTClient(config: courierConfiguration!.build())
        } else {
            return nil
        }
    }
}


class CourierConfigurationParam: Param<MQTTClientConfig> {
    var client : MqttClientParam
    
    override init(value: Dictionary<String, Any?>) {
        client = MqttClientParam(value: [:])
        super.init(value: value)
    }
    
    override func build() -> MQTTClientConfig {
        return client.build()
    }
}

class MqttClientParam: Param<MQTTClientConfig>{
    var configuration: MqttConfigurationParam
    
    override init(value: Dictionary<String, Any?>) {
        self.configuration = MqttConfigurationParam(value: [:])
        super.init(value: value)
    }
    
    override func build() -> MQTTClientConfig {
        return configuration.build()
    }
    
}

class MqttConfigurationParam: Param<MQTTClientConfig> {
    var connectRetryTimePolicy: ConnectRetryTimePolicyParam?
    var connectTimeoutPolicy: ConnectTimeoutPolicyParam?
    var subscriptionRetryPolicy: SubscriptionRetryPolicyParam?
    var unsubscriptionRetryPolicy: SubscriptionRetryPolicyParam?
    var wakeLockTimeout: Int?
    var pingSender: WorkManagerPingSenderConfigParam?
    var experimentConfig: ExperimentConfigParam?
    
    override func build() -> MQTTClientConfig {
        return MQTTClientConfig(
            authService: ConnectionServiceProvider(  // no auth here
                ipAddress: "127.0.0.1",
                port:  1883,
                clientId: "10",
                isCleanSession: true,
                pingInterval:  60),
            messageAdapters: [
                DataMessageAdapter(),
                JSONMessageAdapter(),
                TextMessageAdapter()
            ],
            isMessagePersistenceEnabled: experimentConfig?.isPersistentSubscriptionStoreEnabled ?? false,
            autoReconnectInterval: connectRetryTimePolicy?.reconnectTimeFixed ?? 5,
            maxAutoReconnectInterval: connectRetryTimePolicy?.maxReconnectTime ?? 10,
            enableAuthenticationTimeout: false, // no auth here
            authenticationTimeoutInterval: 30, // no auth here
            connectTimeoutPolicy: connectTimeoutPolicy?.build() ?? ConnectTimeoutPolicy(),
            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(
                isEnabled: true,
                timerInterval: experimentConfig?.adaptiveKeepAliveConfig?.activityCheckIntervalSeconds ?? 12,
                inactivityTimeout: experimentConfig?.adaptiveKeepAliveConfig?.inactivityTimeoutSeconds ?? 10,
                readTimeout: 40
            ),
            messagePersistenceTTLSeconds: experimentConfig?.adaptiveKeepAliveConfig?.incomingMessagesTTLSecs ?? 0,
            messageCleanupInterval: experimentConfig?.adaptiveKeepAliveConfig?.incomingMessagesCleanupIntervalSecs ?? 10
        )
    }
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

class SubscriptionRetryPolicyParam{
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

class ConnectRetryTimePolicyParam {
    var maxRetryCount: Int?
    var reconnectTimeFixed: UInt16?
    var reconnectTimeRandom: Int?
    var maxReconnectTime: UInt16?
}
