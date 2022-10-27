import 'package:json_annotation/json_annotation.dart';
part 'protocol_data_request.g.dart';

/// @author Paul Okeke
/// Moniepoint X TeamApt

@JsonSerializable()
class ProtocolDataRequest {
  final String refNumber;
  final double amount;
  final int transactionType;

  ProtocolDataRequest({
    required this.refNumber,
    required this.amount,
    this.transactionType = 1
  });

  factory ProtocolDataRequest.fromJson(Map<String, dynamic> json) =>
      _$ProtocolDataRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProtocolDataRequestToJson(this);

}