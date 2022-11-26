package com.moniepoint.pos.comms.flutter.handlers

import com.moniepoint.pos.comms.flutter.handlers.Constants.Companion.deviceConnectionMessage

fun sessionMessage(key: String, value: Any? = null): HashMap<Int, Any?> {
   return hashMapOf(Constants.protocolSessionMessage to hashMapOf("key" to key, "value" to value))
}

fun deviceMessage(name: String, address: String): HashMap<String, String> {
   return hashMapOf("deviceName" to name, "deviceAddress" to address)
}

fun deviceStateMessage(address: String, state:Int, errorCode: Int? = null): HashMap<Int, Any?> {
   return hashMapOf(deviceConnectionMessage to
           hashMapOf(
              "deviceAddress" to address,
              "deviceState" to state,
              "deviceErrorCode" to errorCode
           )
   )
}