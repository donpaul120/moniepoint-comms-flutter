import 'package:json_annotation/json_annotation.dart';
part 'peer_device_state.g.dart';

/// @author Paul Okeke
/// Moniepoint X TeamApt

enum DeviceState {
  connected, disconnected, connectionError
}

@JsonSerializable()
class PeerDeviceState {
  final String deviceAddress;

  @JsonKey(fromJson: toDeviceState)
  final DeviceState deviceState;

  @JsonKey(name: "deviceErrorCode")
  final int? errorCode;

  PeerDeviceState({
    required this.deviceAddress,
    required this.deviceState,
    this.errorCode
  });

  static DeviceState toDeviceState(int state) {
    switch(state) {
      case 0:
        return DeviceState.disconnected;
      case 1:
        return DeviceState.connected;
      case 3:
        return DeviceState.connectionError;
      default:
        return DeviceState.disconnected;
    }
  }

  factory PeerDeviceState.fromJson(Map<String, dynamic> json) =>
      _$PeerDeviceStateFromJson(json);

  Map<String, dynamic> toJson() => _$PeerDeviceStateToJson(this);

}