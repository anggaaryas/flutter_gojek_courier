package com.anggaaryas.gojek_courier.model

import com.gojek.courier.QoS

class QosParam(value:String) : EnumParam<QoS>(value) {
    lateinit var qoS: QoS

    init {
        println(value)
        when(value){
            "ZERO" -> qoS = QoS.ZERO
            "ONE" -> qoS = QoS.ONE
            "TWO" -> qoS = QoS.TWO
        }
    }

    override fun build(): QoS {
        return qoS
    }
}