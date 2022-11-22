package com.moniepoint.pos.comms.flutter.handlers

import com.moniepoint.pos.comms.flutter.viewmodels.MoniepointProtocolViewModel
import io.flutter.plugin.common.EventChannel
/**
 * @author Paul Okeke
 * TeamApt x Moniepoint
 */
class ProtocolDataStreamHandler(private val viewModel: MoniepointProtocolViewModel): EventChannel.StreamHandler {
   override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
      viewModel.eventSink = events
   }

   override fun onCancel(arguments: Any?) {
      viewModel.eventSink = null
   }
}