package com.anggaaryas.gojek_courier


import android.content.Context
import android.os.Handler
import android.os.Looper
import com.anggaaryas.gojek_courier.model.ByteMessageAdapter
import com.anggaaryas.gojek_courier.model.ByteMessageAdapterFactory
import com.anggaaryas.gojek_courier.model.CourierParam
import com.anggaaryas.gojek_courier.model.MqttConnectOptionParam
import com.gojek.courier.Courier
import com.gojek.courier.Message
import com.gojek.courier.QoS
import com.gojek.courier.messageadapter.gson.GsonMessageAdapterFactory
import com.gojek.courier.streamadapter.rxjava2.RxJava2StreamAdapterFactory
import com.gojek.mqtt.client.MqttClient
import com.gojek.mqtt.client.listener.MessageListener
import com.gojek.mqtt.client.model.MqttMessage
import timber.log.Timber
import io.flutter.plugin.common.EventChannel
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.disposables.Disposable
import java.util.*

class GojekCourierCore(val receiveSink: EventChannel.EventSink, val logger: Listener, val context: Context) {

    private lateinit var mqttClient: MqttClient
    private lateinit var courierService: MessageService
    private var disposable = CompositeDisposable()
    private var streamList = mutableMapOf<String, Disposable>();

    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())

    fun init(param : CourierParam){
        param.courierConfiguration?.client?.build(context, logger)?.let {
            mqttClient = it

            val courier = Courier(
                configuration = Courier.Configuration(
                    client = it,
                    streamAdapterFactories = listOf(RxJava2StreamAdapterFactory()),
                    messageAdapterFactories = listOf(ByteMessageAdapterFactory())
                )
            )
            courierService = courier.create()
            globalListen()
        }
    }

    fun connect(param: MqttConnectOptionParam){
        param.build(context, logger)?.let { mqttClient.connect(it) }
    }

    fun disconnect(){
        mqttClient.disconnect()
        for ((key, value) in streamList) {
            value.dispose()
        }

        streamList.clear()
    }

    fun subscribe(topic: String, qos: QoS){
        when(qos){
            QoS.ZERO -> courierService.subscribeQosZero(topic = topic)
            QoS.ONE -> courierService.subscribeQosOne(topic = topic)
            QoS.TWO -> courierService.subscribeQosTwo(topic = topic)
        }

    }

    fun unsubscribe(topic: String){
        courierService.unsubscribe(topic = topic)
        streamList[topic]?.dispose()
        streamList.remove(topic)
    }

    @Deprecated("Use ByteArray")
    fun send(topic: String, message: String, qos: QoS){
        when(qos){
            QoS.ZERO -> courierService.sendQosZero(
                topic = topic,
                message = message
            )
            QoS.ONE -> courierService.sendQosOne(
                topic = topic,
                message = message
            )
            QoS.TWO -> courierService.sendQosTwo(
                topic = topic,
                message = message
            )
        }
    }

    fun sendByte(topic: String, message: ByteArray, qos: QoS){
        when(qos){
            QoS.ZERO -> courierService.sendByteQosZero(
                topic = topic,
                message = message
            )
            QoS.ONE -> courierService.sendByteQosOne(
                topic = topic,
                message = message
            )
            QoS.TWO -> courierService.sendByteQosTwo(
                topic = topic,
                message = message
            )
        }
    }

    fun globalListen(){
        mqttClient.addGlobalMessageListener( object : MessageListener {
            override fun onMessageReceived(mqttMessage: MqttMessage) {
                uiThreadHandler.post{
                    receiveSink.success("{\"topic\" : \"${mqttMessage.topic}\", \"data\": ${(mqttMessage.message as Message.Bytes).value.contentToString()}}")
                }

                Timber.tag("Courier-Log").d((mqttMessage.message as Message.Bytes).value.contentToString())

            }
        })
    }

    @Deprecated("Use Global Listen")
    fun listen(topic:String){
        Timber.tag("Courier-Log").d("coba listen $topic...")
        if(!streamList.containsKey(topic)){
            streamList.put(
                topic, courierService.receive(topic).subscribe{
                    uiThreadHandler.post{
                        receiveSink.success("{\"topic\" : \"$topic\", \"data\": ${it.contentToString()}}")
                    }

                    Timber.tag("Courier-Log").d("${it.contentToString()}")
                }
            )
        }
    }
}
