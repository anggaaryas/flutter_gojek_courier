package com.anggaaryas.gojek_courier


import android.content.Context
import android.os.Handler
import android.os.Looper
import com.anggaaryas.gojek_courier.model.CourierParam
import com.anggaaryas.gojek_courier.model.MqttConnectOptionParam
import com.gojek.courier.Courier
import com.gojek.courier.QoS
import com.gojek.courier.streamadapter.rxjava2.RxJava2StreamAdapterFactory
import com.gojek.mqtt.client.MqttClient
import timber.log.Timber
import io.flutter.plugin.common.EventChannel
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.disposables.Disposable
import java.util.*

class GojekCourierCore(val receiveSink: EventChannel.EventSink, val logger: Listener, val context: Context) {

    private var streamList = mutableMapOf<String, MutableMap<String, Disposable>>()
    private var clientList = mutableMapOf<String, MqttClient>()
    private var serviceList = mutableMapOf<String, MessageService>()

    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())

    fun init(id : String , param : CourierParam){
        param.courierConfiguration?.client?.build(context, logger)?.let {
            clientList.put(id, it)

            val courier = Courier(
                configuration = Courier.Configuration(
                    client = it,
                    streamAdapterFactories = listOf(RxJava2StreamAdapterFactory()),
                )
            )

            serviceList.put(id, courier.create())

        }
    }

    fun connect(id : String, param: MqttConnectOptionParam){
        param.build(context, logger)?.let { clientList[id]!!.connect(it) }
    }

    fun disconnect(id: String){
        clientList[id]!!.disconnect()
        for ((key, value) in streamList[id]!!) {
            value.dispose()
        }

        streamList.remove(id)
        clientList.remove(id)
    }

    fun subscribe(id: String, topic: String, qos: QoS){
        when(qos){
            QoS.ZERO -> serviceList[id]!!.subscribeQosZero(topic = topic)
            QoS.ONE -> serviceList[id]!!.subscribeQosOne(topic = topic)
            QoS.TWO -> serviceList[id]!!.subscribeQosTwo(topic = topic)
        }

    }

    fun unsubscribe(id: String, topic: String){
        serviceList[id]!!.unsubscribe(topic = topic)
        streamList[id]!![topic]?.dispose()
        streamList[id]!!.remove(topic)
    }

    fun send(id: String, topic: String, message: String, qos: QoS){
        when(qos){
            QoS.ZERO -> serviceList[id]!!.sendQosZero(
                topic = topic,
                message = message
            )
            QoS.ONE -> serviceList[id]!!.sendQosOne(
                topic = topic,
                message = message
            )
            QoS.TWO -> serviceList[id]!!.sendQosTwo(
                topic = topic,
                message = message
            )
        }
    }

    fun sendByte(id : String, topic: String, message: ByteArray, qos: QoS){
        when(qos){
            QoS.ZERO -> serviceList[id]!!.sendByteQosZero(
                topic = topic,
                message = message
            )
            QoS.ONE -> serviceList[id]!!.sendByteQosOne(
                topic = topic,
                message = message
            )
            QoS.TWO -> serviceList[id]!!.sendByteQosTwo(
                topic = topic,
                message = message
            )
        }
    }

    fun listen(id: String, topic:String){
        Timber.tag("Courier-Log $id").d("coba listen $topic...")
        if(!streamList.containsKey(id)){
            streamList.put(id, mutableMapOf())
        }
        if(!streamList[id]!!.containsKey(topic)){
            streamList[id]!!.put(
                topic, serviceList[id]!!.receive(topic).subscribe{
                    uiThreadHandler.post{
                        receiveSink.success("{\"topic\" : \"$topic\", \"data\": ${it.contentToString()}}")
                    }

                    Timber.tag("Courier-Log $id").d("${it.contentToString()}")
                }
            )
        }
    }
}
