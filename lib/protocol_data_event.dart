import 'dart:async';

import 'package:flutter/services.dart';
import 'package:moniepoint_pos_comms/peer_device_state.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'peer_device.dart';
import 'protocol_data_request.dart';
import 'protocol_data_response.dart';

/// @author Paul Okeke
/// Moniepoint X TeamApt

//Event keys
const int deviceListMessage = 0x01;
const int deviceConnectionMessage = 0x02;
const int protocolSessionMessage = 0x03;

//Session Keys
const String _ack = "ack";
const String _can = "can";
const String _etx = "etx";
const String _response = "response";

//Method Names
const String _cancelMethod = "sendCancel";
const String _endOfTextMethod = "sendEndOfText";
const String _connectToDeviceMethod = "connectToDevice";
const String _orderReqMethod = "startOrderRequest";
const String _listenForDevicesMethod = "listenForDevices";

//Params Key
const String _deviceAddressKey = "deviceAddress";

enum ProtocolEventType {
  deviceList,
  connectionState,
  cancelData,
  endOfTextData,
  acknowledged,
  orderResponse,
  unknown
}

class ProtocolEvent<T> {
  final ProtocolEventType eventType;
  final T? data;
  ProtocolEvent({
    required this.eventType,
    required this.data
  });

  factory ProtocolEvent.can() {
    return ProtocolEvent(eventType: ProtocolEventType.cancelData, data: null);
  }

  factory ProtocolEvent.etx() {
    return ProtocolEvent(eventType: ProtocolEventType.endOfTextData, data: null);
  }

  factory ProtocolEvent.ack() {
    return ProtocolEvent(eventType: ProtocolEventType.acknowledged, data: null);
  }

  static ProtocolEvent<ProtocolDataResponse> orderResponse(ProtocolDataResponse data) {
    return ProtocolEvent<ProtocolDataResponse>(
        eventType: ProtocolEventType.orderResponse, data: data
    );
  }

  static ProtocolEvent<List<PeerDevice>> deviceList(List<PeerDevice> data) {
    return ProtocolEvent<List<PeerDevice>>(
        eventType: ProtocolEventType.deviceList, data: data
    );
  }

  static ProtocolEvent<PeerDeviceState> connectionState(PeerDeviceState data) {
    return ProtocolEvent<PeerDeviceState>(
        eventType: ProtocolEventType.connectionState, data: data
    );
  }
}

abstract class IMoniepointProtocolData extends PlatformInterface {
  IMoniepointProtocolData() : super(token: _token);

  static final Object _token = Object();
  static MoniepointProtocolClient? _client;

  factory IMoniepointProtocolData.getInstance() {
    _client ??= MoniepointProtocolClient._();
    return _client!;
  }

  late Stream<ProtocolEvent> protocolDataStream;
  IMoniepointProtocolData initialize();
  Future<T?> listenForDevicePeers<T>();
  Future<T?> startRequestOrderSession<T>(ProtocolDataRequest request);
  Future<T?> sendCancel<T>();
  Future<T?> sendEndOfText<T>();
  Future<T?> connectToDevice<T>(String deviceAddress);
}

class MoniepointProtocolClient extends IMoniepointProtocolData {
  final _eventChannel = const EventChannel("platform_events/mpos@protocol_event_data");
  final _methodChannel = const MethodChannel("platform_events/mpos@protocol_method_data");

  bool _isInitialized = false;

  final StreamController<ProtocolEvent> _controller = StreamController.broadcast();

  @override
  Stream<ProtocolEvent> get protocolDataStream => _controller.stream;

  MoniepointProtocolClient._();

  @override
  IMoniepointProtocolData initialize() {
    if (_isInitialized) return this;
    _eventChannel.receiveBroadcastStream().listen((event) {
      if (event is! Map) return;

      if (event.containsKey(deviceListMessage)) {
        _processDeviceListMessage(event[deviceListMessage]);
      } else if (event.containsKey(deviceConnectionMessage)) {
        _processDeviceConnectionMessage(event[deviceConnectionMessage]);
      } else if (event.containsKey(protocolSessionMessage)) {
        _processProtocolSessionMessage(event[protocolSessionMessage]);
      }
    });
    _isInitialized = true;
    return this;
  }

  @override
  Future<T?> listenForDevicePeers<T>() {
    return _methodChannel.invokeMethod(_listenForDevicesMethod);
  }

  @override
  Future<T?> startRequestOrderSession<T>(ProtocolDataRequest request) {
    return _methodChannel.invokeMethod(_orderReqMethod, request.toJson());
  }

  @override
  Future<T?> connectToDevice<T>(String deviceAddress) {
    return _methodChannel.invokeMethod(
        _connectToDeviceMethod, {_deviceAddressKey: deviceAddress}
    );
  }

  @override
  Future<T?> sendCancel<T>() {
    return _methodChannel.invokeMethod(_cancelMethod);
  }

  @override
  Future<T?> sendEndOfText<T>() {
    return _methodChannel.invokeMethod(_endOfTextMethod);
  }

  void _processDeviceListMessage(List<dynamic> deviceAddresses) {
    final deviceList = deviceAddresses.map((e) {
      return PeerDevice.fromJson(Map<String, dynamic>.from(e));
    }).toList();
    _controller.sink.add(ProtocolEvent.deviceList(deviceList));
  }

  void _processDeviceConnectionMessage(Map<dynamic, dynamic> map) {
    final deviceState = PeerDeviceState.fromJson(Map<String, dynamic>.from(map));
    _controller.sink.add(ProtocolEvent.connectionState(deviceState));
  }

  void _processProtocolSessionMessage(Map<dynamic, dynamic> map) {
    final key = map["key"];
    final value = map["value"];

    if (_ack == key) _controller.add(ProtocolEvent.ack());
    if (_can == key) _controller.add(ProtocolEvent.can());
    if (_etx == key) _controller.add(ProtocolEvent.etx());

    if (_response == key) {
      final response = ProtocolDataResponse.fromJson(Map<String, dynamic>.from(value));
      _controller.sink.add(ProtocolEvent.orderResponse(response));
    }
  }

}