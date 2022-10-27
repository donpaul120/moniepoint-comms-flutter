import 'package:json_annotation/json_annotation.dart';
part 'protocol_data_response.g.dart';

/// @author Paul Okeke
/// Moniepoint X TeamApt

@JsonSerializable()
class ProtocolDataResponse {
  final String? maskedPan;
  final String? responseCode;
  final String? authorizationCode;
  final String? retrievalRefNo;
  final String? terminalID;
  final String? transDate;
  final String? transTime;

  ProtocolDataResponse(
      {this.maskedPan,
      this.responseCode,
      this.authorizationCode,
      this.retrievalRefNo,
      this.terminalID,
      this.transDate,
      this.transTime});

  factory ProtocolDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ProtocolDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProtocolDataResponseToJson(this);

}