import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moniepoint_pos_comms/protocol_data_event.dart';

void main() {
  IMoniepointProtocolData platform = IMoniepointProtocolData.getInstance();
  const MethodChannel channel = MethodChannel('comms');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
  });
}
