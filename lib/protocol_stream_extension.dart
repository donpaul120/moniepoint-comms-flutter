import 'package:moniepoint_pos_comms/peer_device_state.dart';
import 'package:moniepoint_pos_comms/protocol_data_event.dart';

//@author Paul Okeke

extension ProtocolDataEventStream<T> on Stream<ProtocolEvent<T>> {
  Stream<ProtocolEvent<T>> filterBySessionResponse() {
    return where((event) {
      return event.eventType == ProtocolEventType.acknowledged ||
          event.eventType == ProtocolEventType.orderResponse ||
          event.eventType == ProtocolEventType.cancelData;
    });
  }

  Stream<ProtocolEvent<PeerDeviceState>> filterDeviceStateByAddress(String deviceAddress) {
    return where((event) {
      if (event.eventType != ProtocolEventType.connectionState) {
        return false;
      }
      final data = event.data as PeerDeviceState;
      return data.deviceAddress == deviceAddress;
    }).map((event) => event as ProtocolEvent<PeerDeviceState>);
  }
}