package com.moniepoint.pos.comms.flutter

import androidx.annotation.NonNull
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.ViewModelProvider
import com.moniepoint.pos.comms.MoniepointPosP2p
import com.moniepoint.pos.comms.client.MoniepointPeer
import com.moniepoint.pos.comms.flutter.handlers.ProtocolDataMethodHandler
import com.moniepoint.pos.comms.flutter.handlers.ProtocolDataStreamHandler
import com.moniepoint.pos.comms.flutter.viewmodels.MoniepointProtocolViewModel
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
/**
 * @author Paul Okeke
 * TeamApt x Moniepoint
 *
 * CommsPlugin
 */
class CommsPlugin : FlutterPlugin, ActivityAware {

  private lateinit var client: MoniepointPeer
  private lateinit var viewModel: MoniepointProtocolViewModel

  private lateinit var channel : MethodChannel
  private lateinit var eventChannel: EventChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    client = MoniepointPosP2p.asClient(flutterPluginBinding.applicationContext)
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL_NAME)
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL_NAME)
  }

  private fun setHandlers() {
    if (::client.isInitialized && ::viewModel.isInitialized) {
      channel.setMethodCallHandler(ProtocolDataMethodHandler(viewModel, client))
      eventChannel.setStreamHandler(ProtocolDataStreamHandler(viewModel))
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }

  private fun addClientAsObserver(binding: ActivityPluginBinding) {
    (binding.lifecycle as HiddenLifecycleReference?)
      ?.lifecycle?.addObserver(client as LifecycleObserver)
  }

  private fun removeClientAsObserver(binding: ActivityPluginBinding) {
    (binding.lifecycle as HiddenLifecycleReference?)
      ?.lifecycle?.removeObserver(client as LifecycleObserver)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    val activity = binding.activity
    if (activity is FlutterFragmentActivity) {
      activity.runOnUiThread {
        viewModel = ViewModelProvider(activity)[MoniepointProtocolViewModel::class.java]
        addClientAsObserver(binding)
        setHandlers()
      }
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    addClientAsObserver(binding)
  }

  override fun onDetachedFromActivity() {

  }

  companion object {
    const val EVENT_CHANNEL_NAME = "platform_events/mpos@protocol_event_data"
    const val METHOD_CHANNEL_NAME = "platform_events/mpos@protocol_method_data"
  }
}
