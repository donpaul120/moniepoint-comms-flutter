// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProtocolDataResponse _$ProtocolDataResponseFromJson(
        Map<String, dynamic> json) =>
    ProtocolDataResponse(
      maskedPan: json['maskedPan'] as String?,
      responseCode: json['responseCode'] as String?,
      authorizationCode: json['authorizationCode'] as String?,
      retrievalRefNo: json['retrievalRefNo'] as String?,
      terminalID: json['terminalID'] as String?,
      transDate: json['transDate'] as String?,
      transTime: json['transTime'] as String?,
    );

Map<String, dynamic> _$ProtocolDataResponseToJson(
        ProtocolDataResponse instance) =>
    <String, dynamic>{
      'maskedPan': instance.maskedPan,
      'responseCode': instance.responseCode,
      'authorizationCode': instance.authorizationCode,
      'retrievalRefNo': instance.retrievalRefNo,
      'terminalID': instance.terminalID,
      'transDate': instance.transDate,
      'transTime': instance.transTime,
    };
