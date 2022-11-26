import 'package:json_annotation/json_annotation.dart';
part 'peer_device.g.dart';

/// @author Paul Okeke
/// Moniepoint X TeamApt

@JsonSerializable()
class PeerDevice {
  final String deviceName;
  final String deviceAddress;

  PeerDevice({
    required this.deviceName,
    required this.deviceAddress
  });

  factory PeerDevice.fromJson(Map<String, dynamic> json) =>
      _$PeerDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$PeerDeviceToJson(this);

}