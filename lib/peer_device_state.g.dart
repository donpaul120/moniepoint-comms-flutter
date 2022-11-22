// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peer_device_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeerDeviceState _$PeerDeviceStateFromJson(Map<String, dynamic> json) =>
    PeerDeviceState(
      deviceAddress: json['deviceAddress'] as String,
      deviceState: PeerDeviceState.toDeviceState(json['deviceState'] as int),
      errorCode: json['deviceErrorCode'] as int?,
    );

Map<String, dynamic> _$PeerDeviceStateToJson(PeerDeviceState instance) =>
    <String, dynamic>{
      'deviceAddress': instance.deviceAddress,
      'deviceState': _$DeviceStateEnumMap[instance.deviceState]!,
      'deviceErrorCode': instance.errorCode,
    };

const _$DeviceStateEnumMap = {
  DeviceState.connected: 'connected',
  DeviceState.disconnected: 'disconnected',
  DeviceState.connectionError: 'connectionError',
};
