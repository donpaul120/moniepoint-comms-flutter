// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peer_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeerDevice _$PeerDeviceFromJson(Map<String, dynamic> json) => PeerDevice(
      deviceName: json['name'] as String,
      deviceAddress: json['address'] as String,
    );

Map<String, dynamic> _$PeerDeviceToJson(PeerDevice instance) =>
    <String, dynamic>{
      'name': instance.deviceName,
      'address': instance.deviceAddress,
    };
