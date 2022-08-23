package com.anggaaryas.gojek_courier

import com.gojek.courier.QoS
import com.gojek.courier.annotation.*
import io.reactivex.Observable


interface MessageService {
    @Receive(topic = "{topic}")
    fun receive(@Path("topic") topic: String): Observable<ByteArray>

    @Send(topic = "{topic}", qos = QoS.ZERO)
    fun sendQosZero(@Path("topic") topic: String, @Data message: String)

    @Send(topic = "{topic}", qos = QoS.ONE)
    fun sendQosOne(@Path("topic") topic: String, @Data message: String)

    @Send(topic = "{topic}", qos = QoS.TWO)
    fun sendQosTwo(@Path("topic") topic: String, @Data message: String)

    @Send(topic = "{topic}", qos = QoS.ZERO)
    fun sendByteQosZero(@Path("topic") topic: String, @Data message: ByteArray)

    @Send(topic = "{topic}", qos = QoS.ONE)
    fun sendByteQosOne(@Path("topic") topic: String, @Data message: ByteArray)

    @Send(topic = "{topic}", qos = QoS.TWO)
    fun sendByteQosTwo(@Path("topic") topic: String, @Data message: ByteArray)

    @Subscribe(topic = "{topic}", qos = QoS.ONE)
    fun subscribeQosOne(@Path("topic") topic: String): Observable<String>

    @Subscribe(topic = "{topic}", qos = QoS.TWO)
    fun subscribeQosTwo(@Path("topic") topic: String): Observable<String>

    @Subscribe(topic = "{topic}", qos = QoS.ZERO)
    fun subscribeQosZero(@Path("topic") topic: String): Observable<String>

    @Unsubscribe(topics = ["{topic}"])
    fun unsubscribe(@Path("topic") topic: String)
}