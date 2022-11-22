import 'package:flutter/material.dart';
import 'package:moniepoint_pos_comms/peer_device_state.dart';

class MainViewModel extends ChangeNotifier {

  PeerDeviceState state = PeerDeviceState(
      deviceAddress: "",
      deviceState: DeviceState.disconnected
  );

}