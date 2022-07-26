//
//  MqttConnectOptionParam.swift
//  gojek_courier
//
//  Created by Angga Arya Saputra on 19/07/22.
//

import Foundation
import CourierCore

class MqttConnectOptionParam: Param{
    var serverUri: ServerUriParam?
    var keepAlive: KeepAliveParam?
    var clientId: String?
    var username: String?
    var password: String?
    var isCleanSession: Bool?
    var readTimeoutSecs: Int?
    var version: MqttVersionParam?
    var userPropertiesMap: Dictionary<String, String>?
    
    override init(value: Dictionary<String, Any?>) {
        super.init(value: value)
        setClassParam(value: value["serverUri"] as Any?, onNotNull: {(param) in
            serverUri = ServerUriParam(value: param)
        })
        setClassParam(value: value["keepAlive"] as Any?, onNotNull: {(param) in
            keepAlive = KeepAliveParam(value: param)
        })
        setBasicParam(value: value["clientId"] as Any?, onNotNull: {(param : String) in
            clientId = param
        })
        setBasicParam(value: value["username"] as Any?, onNotNull: {(param : String) in
            username = param
        })
        setBasicParam(value: value["password"] as Any?, onNotNull: {(param : String) in
            password = param
        })
        setBasicParam(value: value["isCleanSession"] as Any?, onNotNull: {(param : Bool) in
            isCleanSession = param
        })
        setBasicParam(value: value["readTimeoutSecs"] as Any?, onNotNull: {(param : Int) in
            readTimeoutSecs = param
        })
        setBasicParam(value: value["version"] as Any?, onNotNull: {(param : String) in
            version = MqttVersionParam(value: param)
        })
        setBasicParam(value: value["userPropertiesMap"] as Any?, onNotNull: {(param : Dictionary<String, String>) in
            userPropertiesMap = param
        })
    }
}


class MqttVersionParam: EnumParam<String>{
    var version: String?
    
    override func build() -> String? {
        return value
    }
}

class KeepAliveParam: Param{
    var timeSeconds: Int?
    var isOptimal: Bool?
    
    override init(value: Dictionary<String, Any?>) {
        super.init(value: value)
        setBasicParam(value: value["timeSeconds"] as Any?, onNotNull: {(param : Int) in
            timeSeconds = param
        })
        setBasicParam(value: value["isOptimal"] as Any?, onNotNull: {(param : Bool) in
            isOptimal = param
        })
    }
}

class ServerUriParam: Param{
    var host: String?
    var port: Int?
    var scheme: String?
    
    override init(value: Dictionary<String, Any?>) {
        super.init(value: value)
        setBasicParam(value: value["host"] as Any?, onNotNull: {(param : String) in
            host = param
        })
        setBasicParam(value: value["port"] as Any?, onNotNull: {(param : Int) in
            port = param
        })
        setBasicParam(value: value["scheme"] as Any?, onNotNull: {(param : String) in
            scheme = param
        })
    }
}
