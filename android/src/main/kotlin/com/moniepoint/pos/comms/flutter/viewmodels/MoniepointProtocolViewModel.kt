package com.moniepoint.pos.comms.flutter.viewmodels

import android.net.wifi.p2p.WifiP2pDevice
import android.net.wifi.p2p.WifiP2pManager
import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.moniepoint.pos.comms.MoniepointPosP2pClientListener
import com.moniepoint.pos.comms.client.MoniepointPeer
import com.moniepoint.pos.comms.data.ProtocolData
import com.moniepoint.pos.comms.data.ProtocolDataMessenger
import com.moniepoint.pos.comms.flutter.handlers.Constants.Companion.deviceConnectionMessage
import com.moniepoint.pos.comms.flutter.handlers.Constants.Companion.deviceListMessage
import com.moniepoint.pos.comms.flutter.handlers.ProtocolDataStreamHandler.Companion.deviceMessage
import com.moniepoint.pos.comms.flutter.handlers.ProtocolDataStreamHandler.Companion.sessionMessage
import com.moniepoint.pos.comms.flutter.handlers.toMap
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch

/**
 * @author Paul Okeke
 * TeamApt x Moniepoint
 */

class MoniepointProtocolViewModel : ViewModel() {

   var eventSink: EventChannel.EventSink? = null
   private var messenger: ProtocolDataMessenger? = null
   private val peerList: MutableList<WifiP2pDevice> = arrayListOf()

   private val peerListListener = object : MoniepointPosP2pClientListener {
      override fun onPeerListUpdated(peerList: Collection<WifiP2pDevice>) {
         this@MoniepointProtocolViewModel.peerList.clear()
         this@MoniepointProtocolViewModel.peerList.addAll(peerList)
         val message = hashMapOf(deviceListMessage to peerList.map {
            deviceMessage(it.deviceName, it.deviceAddress)
         })
         eventSink?.success(message)
      }
   }

   fun initiatePosRequest(client: MoniepointPeer) {
      viewModelScope.launch {
         client.initiatePosRequest(ProtocolData.EnquiryData).collectLatest {
            this@MoniepointProtocolViewModel.messenger = it
            handleProtocolMessages(it)
         }
      }
   }

   private fun handleProtocolMessages(it: ProtocolDataMessenger) {
      when (val message = it.message) {
         is ProtocolData.AcknowledgeData -> eventSink?.success(sessionMessage("ack"))
         is ProtocolData.CancelData -> eventSink?.success(sessionMessage("can"))
         is ProtocolData.EndOfTextData -> eventSink?.success(sessionMessage("etx"))
         is ProtocolData.Response -> {
            eventSink?.success(sessionMessage("response", message.toMap()))
            messenger?.close()
         }
         else -> {
            //do nothing
         }
      }
   }

   fun addPeerDevicesListener(client: MoniepointPeer) {
      client.addPosP2pEventListener(peerListListener)
   }

   /**
    * Connects to the device
    */
   fun connectToDevice(client: MoniepointPeer, deviceAddress: String?) {
      if (null == deviceAddress) {
         return
      }

      client.connect(deviceAddress, object : WifiP2pManager.ActionListener {
         override fun onSuccess() {
            eventSink?.success(hashMapOf(deviceConnectionMessage to "$deviceAddress:1"))
         }

         override fun onFailure(p0: Int) {
            eventSink?.success(hashMapOf(deviceConnectionMessage to "$deviceAddress:0:$p0"))
         }
      })
   }

   fun sendStandardMessage(protocolData: ProtocolData) {
      viewModelScope.launch { messenger?.replyMessage(protocolData) }
   }
}