package com.anggaaryas.gojek_courier

import android.os.Handler
import android.os.Looper
import com.gojek.courier.logging.ILogger
import com.gojek.mqtt.event.EventHandler
import com.gojek.mqtt.event.MqttEvent
import com.gojek.mqtt.exception.handler.v3.AuthFailureHandler
import com.google.gson.GsonBuilder
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
            Timber.tag(topic).v(msg)
            sendToFlutter(Type.VERBOSE, tag, msg, loggerSink)
        }

        override fun v(tag: String, msg: String, tr: Throwable) {
            Timber.tag(topic).v(tr, msg)
            sendToFlutter(Type.VERBOSE, tag, msg, loggerSink)
        }

        override fun d(tag: String, msg: String) {
            Timber.tag(topic).d(msg)
            sendToFlutter(Type.DEBUG, tag, msg, loggerSink)
        }

        override fun d(tag: String, msg: String, tr: Throwable) {
            Timber.tag(topic).d(tr, msg)
            sendToFlutter(Type.DEBUG, tag, msg, loggerSink)
        }

        override fun i(tag: String, msg: String) {
            Timber.tag(topic).i(msg)
            sendToFlutter(Type.INFO, tag, msg, loggerSink)
        }

        override fun i(tag: String, msg: String, tr: Throwable) {
            Timber.tag(topic).i(tr, msg)
            sendToFlutter(Type.INFO, tag, msg, loggerSink)
        }

        override fun w(tag: String, msg: String) {
            Timber.tag(topic).w(msg)
            sendToFlutter(Type.WARNING, tag, msg, loggerSink)
        }

        override fun w(tag: String, msg: String, tr: Throwable) {
            Timber.tag(topic).w(tr, msg)
            sendToFlutter(Type.WARNING, tag, msg, loggerSink)
        }

        override fun w(tag: String, tr: Throwable) {
            Timber.tag(topic).d(tr)
            sendToFlutter(Type.WARNING, tag, tr.cause?.message ?: "", loggerSink)
        }

        override fun e(tag: String, msg: String) {
            Timber.tag(topic).e(msg)
            sendToFlutter(Type.ERROR, tag, msg, loggerSink)
        }

        override fun e(tag: String, msg: String, tr: Throwable) {
            Timber.tag(topic).e(tr, msg)
            sendToFlutter(Type.ERROR, tag, msg, loggerSink)
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
                    "{\"topic\" : \"$tag\", \"type\" : \"$typeString\", \"data\": \"${
                        msg.replace(
                            "\"",
                            ""
                        )
                    }\"}"
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
            val tag = mqttEvent.javaClass.name

            val json = gson.toJson(mqttEvent)

            val jsonElement = JsonParser.parseString(json)
            val jsonObject = jsonElement.getAsJsonObject()
            jsonObject.addProperty("connectionInfo", gson.toJson(mqttEvent.connectionInfo))
            val json2: String = jsonObject.toString()

            sendToFlutter(Type.EVENT, tag, json2 , eventSink)
            Timber.tag("Courier").d("Received event: $json2")
        }
    }

    val authFailureHandler = object : AuthFailureHandler {
        override fun handleAuthFailure() {
            sendToFlutter(Type.EVENT, "auth_failure_handler", "", authErrorSink)
            Timber.tag("Courier").d("auth failure")
        }
    }
}