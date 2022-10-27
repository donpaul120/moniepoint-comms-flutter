package com.moniepoint.pos.comms.flutter.handlers

import android.util.Log
import com.moniepoint.pos.comms.flutter.handlers.Constants.Companion.protocolSessionMessage
import com.moniepoint.pos.comms.flutter.viewmodels.MoniepointProtocolViewModel
import io.flutter.plugin.common.EventChannel
/**
 * @author Paul Okeke
 * TeamApt x Moniepoint
 */
class ProtocolDataStreamHandler(private val viewModel: MoniepointProtocolViewModel): EventChannel.StreamHandler {
   override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
      viewModel.eventSink = events
      Log.e("TAG", "Started Listening to event")
   }

   override fun onCancel(arguments: Any?) {
      viewModel.eventSink = null
   }

   companion object {
      fun sessionMessage(key: String, value: Any? = null): HashMap<Int, Any?> {
         return hashMapOf(protocolSessionMessage to hashMapOf("key" to key, "value" to value))
      }
      fun deviceMessage(name: String, address: String): HashMap<String, String> {
         return hashMapOf("name" to name, "address" to address)
      }
   }
}