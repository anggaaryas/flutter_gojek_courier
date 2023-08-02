package com.anggaaryas.gojek_courier

import android.os.Handler
import android.os.Looper
import android.util.Log
import com.gojek.courier.logging.ILogger
import com.gojek.mqtt.event.EventHandler
import com.gojek.mqtt.event.MqttEvent
import com.gojek.mqtt.exception.handler.v3.AuthFailureHandler
import com.google.gson.GsonBuilder
import com.google.gson.JsonElement
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import io.flutter.plugin.common.EventChannel
import timber.log.Timber


class Listener(val loggerSink : EventChannel.EventSink?, val eventSink : EventChannel.EventSink?, val authErrorSink : EventChannel.EventSink?){
    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())
    private val gson = GsonBuilder().setExclusionStrategies(MqttEventWxclusionStrategy()).create()

    enum class Type{
        VERBOSE,
        INFO,
        DEBUG,
        WARNING,
        ERROR,
        EVENT
    }

    fun getLogger(topic:String) = object : ILogger {
        override fun v(tag: String, msg: String) {
            sendToFlutter(Type.VERBOSE, tag, msg.toByteArray().contentToString(), loggerSink)
        }

        override fun v(tag: String, msg: String, tr: Throwable) {
            sendToFlutter(Type.VERBOSE, tag, msg.toByteArray().contentToString(), loggerSink)
        }

        override fun d(tag: String, msg: String) {
            sendToFlutter(Type.DEBUG, tag, msg.toByteArray().contentToString(), loggerSink)
        }

        override fun d(tag: String, msg: String, tr: Throwable) {
            sendToFlutter(Type.DEBUG, tag, msg.toByteArray().contentToString(), loggerSink)
        }

        override fun i(tag: String, msg: String) {
            sendToFlutter(Type.INFO, tag, msg.toByteArray().contentToString(), loggerSink)
        }

        override fun i(tag: String, msg: String, tr: Throwable) {
            sendToFlutter(Type.INFO, tag, msg.toByteArray().contentToString(), loggerSink)
        }

        override fun w(tag: String, msg: String) {
            sendToFlutter(Type.WARNING, tag, msg.toByteArray().contentToString(), loggerSink)
        }

        override fun w(tag: String, msg: String, tr: Throwable) {
            sendToFlutter(Type.WARNING, tag, msg.toByteArray().contentToString(), loggerSink)
        }

        override fun w(tag: String, tr: Throwable) {
            sendToFlutter(Type.WARNING, tag, tr.cause?.message ?: "", loggerSink)
        }

        override fun e(tag: String, msg: String) {
            sendToFlutter(Type.ERROR, tag, msg.toByteArray().contentToString(), loggerSink)
        }

        override fun e(tag: String, msg: String, tr: Throwable) {
            sendToFlutter(Type.ERROR, tag, msg.toByteArray().contentToString(), loggerSink)
        }
    }

    private fun sendToFlutter(type: Type, tag: String, msg: String, sink: EventChannel.EventSink?) {
        val typeString = when(type){
            Type.VERBOSE -> "verbose"
            Type.INFO -> "info"
            Type.DEBUG -> "debug"
            Type.WARNING -> "warning"
            Type.ERROR -> "error"
            Type.EVENT -> "event"
        }
        uiThreadHandler.post {
            if(type != Type.EVENT){
                sink?.success(
                    "{\"topic\" : \"$tag\", \"type\" : \"$typeString\", \"data\": ${
                        msg.replace(
                            "\"",
                            ""
                        )
                    }}"
                )
            } else {
                sink?.success(
                    "{\"topic\" : \"$tag\", \"type\" : \"$typeString\", \"data\": $msg}"
                )
            }
        }
    }

    val eventHandler = object : EventHandler {

        private fun generateMessage(map: Map<String, Any>) : String{
            return ""
        }

        override fun onEvent(mqttEvent: MqttEvent) {
            try {
                val tag = mqttEvent.javaClass.name

                val json = gson.toJson(mqttEvent)

                val jsonElement = JsonParser.parseString(json)
                val jsonObject = jsonElement.getAsJsonObject()
                val conInfo = mqttEvent.connectionInfo
                if (conInfo != null) {
                    jsonObject.add(
                        "connectionInfo",
                        JsonObject()
                    )
                    val conInfoJsonObj = jsonObject.getAsJsonObject("connectionInfo")
                    conInfoJsonObj.addProperty("clientId", conInfo.clientId)
                    conInfoJsonObj.addProperty("username", conInfo.username)
                    conInfoJsonObj.addProperty("keepaliveSeconds", conInfo.keepaliveSeconds)
                    conInfoJsonObj.addProperty("connectTimeout", conInfo.connectTimeout)
                    conInfoJsonObj.addProperty("host", conInfo.host)
                    conInfoJsonObj.addProperty("port", conInfo.port)
                    conInfoJsonObj.addProperty("scheme", conInfo.scheme)
                }
                val json2: String = jsonObject.toString()

                sendToFlutter(Type.EVENT, tag, json2, eventSink)
            } catch (e: Exception){
                println("NATIVE EVENT ERROR: $e");
            }
        }
    }

    val authFailureHandler = object : AuthFailureHandler {
        override fun handleAuthFailure() {
            sendToFlutter(Type.EVENT, "auth_failure_handler", "", authErrorSink)
        }
    }
}