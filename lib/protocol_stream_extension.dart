import 'package:moniepoint_pos_comms/peer_device_state.dart';
import 'package:moniepoint_pos_comms/protocol_data_event.dart';

//@author Paul Okeke

extension ProtocolDataEventStream<T> on Stream<ProtocolEvent<T>> {
  Stream<ProtocolEvent<T>> filterForOrderResponse() {
    return where((event) {
      print("Object has been received here!!!! ${event}");
      return event.eventType == ProtocolEventType.acknowledged ||
          event.eventType == ProtocolEventType.orderResponse ||
          event.eventType == ProtocolEventType.cancelData;
    });
  }

  Stream<ProtocolEvent<PeerDeviceState>> filterForDeviceState(String deviceAddress) {
    return where((event) {
      if (event.eventType != ProtocolEventType.connectionState) {
        return false;
      }
      final data = event.data as PeerDeviceState;
      return data.deviceAddress == deviceAddress;
    }).map((event) => event as ProtocolEvent<PeerDeviceState>);
  }
}