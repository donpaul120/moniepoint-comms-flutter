// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol_data_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProtocolDataRequest _$ProtocolDataRequestFromJson(Map<String, dynamic> json) =>
    ProtocolDataRequest(
      refNumber: json['refNumber'] as String,
      amount: (json['amount'] as num).toDouble(),
      transactionType: json['transactionType'] as int? ?? 1,
    );

Map<String, dynamic> _$ProtocolDataRequestToJson(
        ProtocolDataRequest instance) =>
    <String, dynamic>{
      'refNumber': instance.refNumber,
      'amount': instance.amount,
      'transactionType': instance.transactionType,
    };
