package com.anggaaryas.gojek_courier

import io.flutter.plugin.common.EventChannel
import timber.log.Timber
import java.util.*

abstract class StreamHandler: EventChannel.StreamHandler {
    var sink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Timber.tag("Courier-Log").d("add stream...")
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }
}

class ReceiveStreamHandler : StreamHandler()

class LoggerStreamHandler : StreamHandler()

class EventStreamHandler : StreamHandler()

class AuthFailStreamHandler : StreamHandler()
