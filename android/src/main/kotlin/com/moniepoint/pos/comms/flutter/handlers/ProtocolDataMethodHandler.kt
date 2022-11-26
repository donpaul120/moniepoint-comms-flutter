package com.moniepoint.pos.comms.flutter.handlers

import com.moniepoint.pos.comms.client.MoniepointPeer
import com.moniepoint.pos.comms.data.ProtocolData
import com.moniepoint.pos.comms.flutter.viewmodels.MoniepointProtocolViewModel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * @author Paul Okeke
 * TeamApt x Moniepoint
 */
class ProtocolDataMethodHandler(
   private val viewModel: MoniepointProtocolViewModel,
   private val client: MoniepointPeer
) : MethodChannel.MethodCallHandler {
   override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
      when (call.method) {
         LISTEN_FOR_DEVICES -> viewModel.addPeerDevicesListener(client)
         CONNECT_TO_DEVICE -> {
            val address = call.argument<String?>(DEVICE_ADDRESS_KEY)
            viewModel.connectToDevice(client, address)
         }
         SEND_CANCEL -> {
            viewModel.sendStandardMessage(ProtocolData.CancelData)
            viewModel.closeMessenger()
         }
         SEND_END_OF_TEXT -> viewModel.sendStandardMessage(ProtocolData.EndOfTextData)
         START_ORDER_REQUEST -> viewModel.initiatePosRequest(client)
         SEND_REQUEST -> return sendRequest(call, result)
         else -> return result.notImplemented()
      }
      result.success("")
   }

   private fun sendRequest(call: MethodCall, result: MethodChannel.Result) {
      val transactionType = call.argument<Int>(TRANSACTION_TYPE_KEY)
      val refNumber = call.argument<String>(REFERENCE_NUMBER_KEY)
      val amount = call.argument<Double>(AMOUNT_KEY)

      if (null == amount || null == refNumber || null == transactionType) {
         return result.error(
            INVALID_REQUEST,
            INVALID_REQUEST_MSG,
            "Amount ${null == amount}; " +
                    "RefNumber ${null == refNumber}; " +
                    "Type ${null == transactionType}"
         )
      }

      val request = ProtocolData.Request.Builder()
         .transactionType(transactionType)
         .referenceNumber(refNumber)
         .amount(amount)

      viewModel.sendStandardMessage(request.build())
      return result.success("")
   }

   companion object {
      //Method Names
      const val LISTEN_FOR_DEVICES = "listenForDevices"
      const val CONNECT_TO_DEVICE = "connectToDevice"
      const val START_ORDER_REQUEST = "startOrderRequest"
      const val SEND_REQUEST = "sendProtocolDataRequest"
      const val SEND_CANCEL = "sendCancel"
      const val SEND_END_OF_TEXT = "sendEndOfText"

      //Parameter Names
      const val DEVICE_ADDRESS_KEY = "deviceAddress"
      const val TRANSACTION_TYPE_KEY = "transactionType"
      const val REFERENCE_NUMBER_KEY = "refNumber"
      const val AMOUNT_KEY = "amount"

      //Error Codes
      const val INVALID_REQUEST = "INVALID_REQ"
      const val INVALID_REQUEST_MSG = "Invalid Request Payload"
   }
}