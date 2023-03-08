package com.anggaaryas.gojek_courier.model

import com.gojek.courier.Message
import com.gojek.courier.MessageAdapter
import java.lang.reflect.Type

class ByteMessageAdapter: MessageAdapter<ByteArray> {
    override fun contentType(): String = "application/octet-stream"

    override fun fromMessage(topic: String, message: Message): ByteArray = (message as Message.Bytes).value

    override fun toMessage(topic: String, data: ByteArray): Message = Message.Bytes(data)

}

class ByteMessageAdapterFactory: MessageAdapter.Factory{
    override fun create(type: Type, annotations: Array<Annotation>): MessageAdapter<*> {
        return ByteMessageAdapter()
    }

}