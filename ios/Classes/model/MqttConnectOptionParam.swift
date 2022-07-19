//
//  MqttConnectOptionParam.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 19/07/22.
//

import Foundation
import CourierCore

class MqttConnectOptionParam: Param<ConnectOptions>{
    var serverUris: ServerUriParam?
    var keepAlive: KeepAliveParam?
    var clientId: String?
    var username: String?
    var password: String?
    var isCleanSession: Bool?
    var readTimeoutSecs: Int?
    var version: MqttVersionParam?
    var userPropertiesMap: Dictionary<String, String>?
}


class MqttVersionParam{
    var version: String?
}

class KeepAliveParam{
    var timeSeconds: Int?
    var isOptimal: Bool?
}

class ServerUriParam {
    var host: String?
    var port: Int?
    var scheme: String?
}
