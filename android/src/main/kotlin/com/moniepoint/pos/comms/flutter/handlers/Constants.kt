package com.moniepoint.pos.comms.flutter.handlers

import com.moniepoint.pos.comms.data.ProtocolData
/**
 * @author Paul Okeke
 * TeamApt x Moniepoint
 */

class Constants {
   companion object {
      const val deviceListMessage = 0x01
      const val deviceConnectionMessage = 0x02
      const val protocolSessionMessage = 0x03
   }
}

fun ProtocolData.Response.toMap() : HashMap<String, String?> {
   return hashMapOf(
      "maskedPan" to maskedPan,
      "authorizationCode" to authorizationCode,
      "responseCode" to responseCode,
      "retrievalRefNo" to retrievalRefNo,
      "terminalID" to terminalID,
      "transDate" to transDate,
      "transTime" to transTime
   )
}