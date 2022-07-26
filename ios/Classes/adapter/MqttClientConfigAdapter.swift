//
//  MqttConfigAdapter.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 19/07/22.
//

import Foundation
import CourierMQTT

class MqttClientConfigAdapter{
    let mqttConfig: MqttConfigurationParam
    let connectOption: MqttConnectOptionParam
    
    init(mqttConfig: MqttConfigurationParam, connectOption: MqttConnectOptionParam){
        self.connectOption = connectOption
        self.mqttConfig = mqttConfig
    }
    
    func build() -> MQTTClientConfig{
        return MQTTClientConfig(
            authService: ConnectionServiceProvider(
                ipAddress: connectOption.serverUri!.host!,
                port: connectOption.serverUri!.port!,
                clientId: connectOption.clientId!,
                username: connectOption.username,
                password: connectOption.password,
                isCleanSession: connectOption.isCleanSession ?? false,
                pingInterval: connectOption.keepAlive?.timeSeconds ?? 30
            ),
            messageAdapters: [
                DataMessageAdapter(),
                JSONMessageAdapter(),
                TextMessageAdapter()
            ],
            isMessagePersistenceEnabled: mqttConfig.experimentConfig?.isPersistentSubscriptionStoreEnabled ?? false,
            autoReconnectInterval: mqttConfig.connectRetryTimePolicy?.reconnectTimeFixed ?? 5,
            maxAutoReconnectInterval: mqttConfig.connectRetryTimePolicy?.maxReconnectTime ?? 10,
            enableAuthenticationTimeout: false, 
            authenticationTimeoutInterval: 30,
            connectTimeoutPolicy: ConnectTimeoutPolicy(
                isEnabled: mqttConfig.connectTimeoutPolicy != nil,
                timerInterval: 16,
                timeout: mqttConfig.connectTimeoutPolicy?.sslUpperBoundConnTimeOut ?? 10
            ),
            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(
                isEnabled: true,
                timerInterval: mqttConfig.experimentConfig?.adaptiveKeepAliveConfig?.activityCheckIntervalSeconds ?? 12,
                inactivityTimeout: mqttConfig.experimentConfig?.adaptiveKeepAliveConfig?.inactivityTimeoutSeconds ?? 10,
                readTimeout: 40
            ),
            messagePersistenceTTLSeconds: mqttConfig.experimentConfig?.adaptiveKeepAliveConfig?.incomingMessagesTTLSecs ?? 0,
            messageCleanupInterval: mqttConfig.experimentConfig?.adaptiveKeepAliveConfig?.incomingMessagesCleanupIntervalSecs ?? 10
        )
    }
}
