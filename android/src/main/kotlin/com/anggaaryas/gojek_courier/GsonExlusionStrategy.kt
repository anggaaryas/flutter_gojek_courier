package com.anggaaryas.gojek_courier

import com.gojek.mqtt.event.MqttEvent
import com.google.gson.ExclusionStrategy
import com.google.gson.FieldAttributes


class MqttEventWxclusionStrategy : ExclusionStrategy {
    override fun shouldSkipClass(arg0: Class<*>?): Boolean {
        return false
    }

    override fun shouldSkipField(f: FieldAttributes): Boolean {
        return f.declaringClass == MqttEvent::class.java && f.name == "connectionInfo"
    }
}