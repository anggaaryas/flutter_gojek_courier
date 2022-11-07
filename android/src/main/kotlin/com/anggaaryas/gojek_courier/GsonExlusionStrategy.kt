package com.anggaaryas.gojek_courier

import com.gojek.mqtt.event.MqttEvent
import com.google.gson.ExclusionStrategy
import com.google.gson.FieldAttributes
import java.lang.reflect.Field


class MqttEventWxclusionStrategy : ExclusionStrategy {
    override fun shouldSkipClass(arg0: Class<*>?): Boolean {
        return false
    }

    override fun shouldSkipField(f: FieldAttributes): Boolean {
        val fieldName: String = f.name
        val theClass: Class<*> = f.declaringClass

        return (f.declaringClass == MqttEvent::class.java && f.name == "connectionInfo" ) || isFieldInSuperclass(theClass, fieldName)
    }

    private fun isFieldInSuperclass(subclass: Class<*>, fieldName: String): Boolean {
        var superclass = subclass.superclass
        var field: Field?
        while (superclass != null) {
            field = getField(superclass, fieldName)
            if (field != null) return true
            superclass = superclass.superclass
        }
        return false
    }

    private fun getField(theClass: Class<*>, fieldName: String): Field? {
        return try {
            theClass.getDeclaredField(fieldName)
        } catch (e: Exception) {
            null
        }
    }
}