package com.anggaaryas.gojek_courier


import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import com.anggaaryas.gojek_courier.model.CourierParam
import com.anggaaryas.gojek_courier.model.MqttConnectOptionParam
import com.anggaaryas.gojek_courier.model.QosParam
import com.gojek.courier.QoS
import com.google.gson.GsonBuilder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import org.json.JSONObject
import timber.log.Timber
import java.util.*


/** GojekCourierPlugin */
class GojekCourierPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel

    lateinit var context: Context
    lateinit var logger: Listener

    private lateinit var activity: Activity
    private lateinit var receiveDataStream: EventChannel
    private lateinit var loggerStream: EventChannel
    private lateinit var eventStream: EventChannel
    private lateinit var authFailStream: EventChannel

    private var gson = GsonBuilder().create()

    private lateinit var library : GojekCourierCore

    private val receiveDataStreamHandler = ReceiveStreamHandler()
    private  val loggerStreamHandler = LoggerStreamHandler()
    private  val eventStreamHandler = EventStreamHandler()
    private  val authFailStreamHandler = AuthFailStreamHandler()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "gojek_courier")
        channel.setMethodCallHandler(this)

        receiveDataStream = EventChannel(flutterPluginBinding.binaryMessenger, "receive_data_channel")
        receiveDataStream.setStreamHandler(receiveDataStreamHandler)

        loggerStream = EventChannel(flutterPluginBinding.binaryMessenger, "logger_channel")
        loggerStream.setStreamHandler(loggerStreamHandler)

        eventStream = EventChannel(flutterPluginBinding.binaryMessenger, "event_channel")
        eventStream.setStreamHandler(eventStreamHandler)

        authFailStream = EventChannel(flutterPluginBinding.binaryMessenger, "auth_fail_channel")
        authFailStream.setStreamHandler(authFailStreamHandler)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        Timber.tag("Courier-stream").d("call ${call.method}...")


        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "initialise" -> {
                logger = Listener(loggerStreamHandler.sink!!, eventStreamHandler.sink!!, authFailStreamHandler.sink!!)
                library = GojekCourierCore(receiveDataStreamHandler.sink!!, logger, context)
                val param : Map<String, Any> = call.arguments()!!
                val courierParam = CourierParam(param)
                library.init(courierParam)
                result.success("")
            }
            "connect" -> {
                val param : Map<String, Any> = call.arguments()!!
                val connectParam = MqttConnectOptionParam(param)
                library.connect(connectParam)
                result.success("")
            }
            "disconnect" -> {
                library.disconnect()
                result.success("")
            }
            "subscribe" -> {
                if(receiveDataStreamHandler.sink == null){
                    Timber.tag("Courier-stream").d("method call events null...")
                }
                val qos : QoS = QosParam(call.argument("qos")!!).build()
                library.subscribe(call.argument("topic")!!, qos)
                library.listen(call.argument("topic")!!)
                result.success("")
            }
            "unsubscribe" -> {
                library.unsubscribe(call.argument("topic")!!)
                result.success("")
            }
            "send" -> {
                val topic: String = call.argument("topic")!!
                val message : String = call.argument("msg")!!
                val qos : QoS = QosParam(call.argument("qos")!!).build()
                library.send(topic, message, qos)
                result.success("")
            }
            "sendByte" -> {
                val topic: String = call.argument("topic")!!
                val message : ByteArray = call.argument("msg")!!
                val qos : QoS = QosParam(call.argument("qos")!!).build()
                library.sendByte(topic, message, qos)
                result.success("")
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
        Timber.plant(Timber.DebugTree())
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }
}
