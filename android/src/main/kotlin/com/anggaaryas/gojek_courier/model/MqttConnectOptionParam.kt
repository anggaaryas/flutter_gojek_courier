package com.anggaaryas.gojek_courier.model

import android.content.Context
import com.anggaaryas.gojek_courier.Listener
import com.gojek.mqtt.model.KeepAlive
import com.gojek.mqtt.model.MqttConnectOptions
import com.gojek.mqtt.model.MqttVersion
import com.gojek.mqtt.model.ServerUri
import java.util.*


class MqttConnectOptionParam(value: Map<String, Any?>): Param<MqttConnectOptions>(value) {
    var serverUri: ServerUriParam? = null
    var keepAlive: KeepAliveParam? = null
    var clientId: String? = null
    var username: String? = null
    var password: String? = null
    var isCleanSession: Boolean? = null
    var readTimeoutSecs: Int? = null
    var version: MqttVersionParam? = null
    var userPropertiesMap: Map<String, String>? = null

    init {
        value.getValue("serverUri")?.let {
            serverUri = ServerUriParam(it as Map<String, Any?>)
        }
        value.getValue("keepAlive")?.let {
            keepAlive = KeepAliveParam(it as Map<String, Any?>)
        }
        value.getValue("clientId")?.let {
            clientId = it as String
        }
        value.getValue("username")?.let {
            username = it as String
        }
        value.getValue("password")?.let {
            password = it as String
        }
        value.getValue("isCleanSession")?.let {
            isCleanSession = it as Boolean
        }
        value.getValue("readTimeoutSecs")?.let {
            readTimeoutSecs = it as Int
        }
        value.getValue("version")?.let {
            version = MqttVersionParam(it as String)
        }
        value.getValue("userPropertiesMap")?.let {
            userPropertiesMap = it as Map<String, String>
        }
    }

    override fun build(context: Context, logger: Listener): MqttConnectOptions? {
        val temp = mutableListOf<ServerUri>()
        if(serverUri != null){
            val build = serverUri!!.build(context, logger)
            temp.add(build)
        }

        return keepAlive?.build(context, logger)?.let {
            MqttConnectOptions(
                serverUris = Collections.unmodifiableList(temp),
                clientId = clientId ?: "",
                isCleanSession = isCleanSession ?: false,
                keepAlive = it,
                password = password ?: "",
                username = username ?: "",
                readTimeoutSecs = readTimeoutSecs ?: -1,
                userPropertiesMap = userPropertiesMap ?: emptyMap(),
                version = version?.build() ?: MqttVersion.VERSION_3_1_1,
            )
        }
    }
}

class MqttVersionParam(value: String): EnumParam<MqttVersion>(value){
    var version: MqttVersion? = null

    init {
        when(value){
            "MQTT" -> {
                version = MqttVersion.VERSION_3_1_1
            }
            "MQIsdp" -> {
                version = MqttVersion.VERSION_3_1
            }
            else -> {
                version = MqttVersion.VERSION_3_1_1
            }
        }
    }

    override fun build(): MqttVersion {
        return version!!
    }
}

class KeepAliveParam(value: Map<String, Any?>): Param<KeepAlive>(value) {
    var timeSeconds: Int? = null
    var isOptimal: Boolean? = null

    init {
        value.getValue("timeSeconds")?.let {
            timeSeconds = it as Int
        }
        value.getValue("isOptimal")?.let {
            isOptimal = it as Boolean
        }
    }

    override fun build(context: Context, logger: Listener): KeepAlive {
        return KeepAlive(
            timeSeconds = timeSeconds ?: 0,
            isOptimal = isOptimal?: false
        )
    }
}

class ServerUriParam(value: Map<String, Any?>): Param<ServerUri>(value) {
    var host: String? = null
    var port: Int? = null
    var scheme: String? = null

    init {
        value.getValue("host")?.let {
            host = it as String
        }
        value.getValue("port")?.let {
            port = it as Int
        }
        value.getValue("scheme")?.let {
            scheme = it as String
        }
    }

    override fun build(context: Context, logger: Listener): ServerUri {
        return ServerUri(
            host = host!!,
            port = port!!,
            scheme = scheme ?: "ssl"
        )
    }
}
