
import 'package:flutter_test/flutter_test.dart';
import 'package:moniepoint_pos_comms/protocol_data_event.dart';
import 'package:moniepoint_pos_comms/protocol_data_request.dart';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCommsPlatform
    with MockPlatformInterfaceMixin
    implements MoniepointProtocolClient {
  @override
  Stream<ProtocolEvent> protocolDataStream = const Stream.empty();

  @override
  Future<T?> connectToDevice<T>(String deviceAddress) {
    // TODO: implement connectToDevice
    throw UnimplementedError();
  }

  @override
  IMoniepointProtocolData initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<T?> listenForDevicePeers<T>() {
    // TODO: implement listenForDevicePeers
    throw UnimplementedError();
  }

  @override
  Future<T?> sendCancel<T>() {
    // TODO: implement sendCancel
    throw UnimplementedError();
  }

  @override
  Future<T?> sendEndOfText<T>() {
    // TODO: implement sendEndOfText
    throw UnimplementedError();
  }

  @override
  Future<T?> startRequestOrderSession<T>(ProtocolDataRequest request) {
    // TODO: implement startRequestOrderSession
    throw UnimplementedError();
  }

}

void main() {
  final IMoniepointProtocolData initialPlatform = IMoniepointProtocolData.getInstance();
  //
  // test('$MethodChannelComms is the default instance', () {
  //   expect(initialPlatform, isInstanceOf<MethodChannelComms>());
  // });
  //
  // test('getPlatformVersion', () async {
  //   Comms commsPlugin = Comms();
  //   MockCommsPlatform fakePlatform = MockCommsPlatform();
  //   CommsPlatform.instance = fakePlatform;
  //
  //   expect(await commsPlugin.getPlatformVersion(), '42');
  // });
}
