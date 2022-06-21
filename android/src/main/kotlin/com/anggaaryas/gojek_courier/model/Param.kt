package com.anggaaryas.gojek_courier.model

import android.content.Context
import com.anggaaryas.gojek_courier.Listener
import com.google.gson.Gson
import com.google.gson.GsonBuilder


abstract class Param<T>(val value: Map<String, Any?>){
    val gson = GsonBuilder().create()

    abstract fun build(context: Context, logger: Listener) : T?

    fun toJson() : String{
        return gson.toJson(this)
    }
}

abstract class  EnumParam<T>(val value: String){
    abstract fun build() : T?
}
