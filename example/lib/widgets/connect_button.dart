import 'package:comms_example/colors.dart';
import 'package:comms_example/core/app_route.dart';
import 'package:comms_example/main_view_model.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_pos_comms/peer_device.dart';
import 'package:moniepoint_pos_comms/peer_device_state.dart';
import 'package:moniepoint_pos_comms/protocol_data_event.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ConnectButton extends StatefulWidget {
  const ConnectButton({
    required this.peerDevice,
    super.key
  });

  final PeerDevice peerDevice;

  @override
  State<StatefulWidget> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> {

  late final IMoniepointProtocolData moniepointClient;
  late final PeerDevice peerDevice;
  late final MainViewModel _viewModel;
  late final Stream<ProtocolEvent<PeerDeviceState>> _dataStream;

  PeerDeviceState? _deviceState;

  @override
  void initState() {
    _viewModel = Provider.of<MainViewModel>(context, listen: false);
    moniepointClient = IMoniepointProtocolData.getInstance();
    peerDevice = widget.peerDevice;
    _dataStream = deviceStateStream;
    super.initState();
  }

  Stream<ProtocolEvent<PeerDeviceState>> get deviceStateStream {
    return moniepointClient.protocolDataStream
        .where((event) {
          print("Filtering Connection state ooo ${event.eventType}");
          if (event.eventType != ProtocolEventType.connectionState) {
            print("Filtering and False ${event.eventType}");
            return false;
          }
          final data = event.data as PeerDeviceState;
          print("Filtering DATA DATA ooo ${event.eventType}");
          return data.deviceAddress == peerDevice.deviceAddress;
        }).map((event) => event as ProtocolEvent<PeerDeviceState>);
  }

  bool canConnect(DeviceState? state) {
    if (state == DeviceState.connected) return false;
    return true;
  }

  void _openOrderScreen() {
    Navigator.of(context).pushNamed(AppRoute.orderListScreen);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _dataStream,
        builder: (ctx, snapshot) {
          _viewModel.state = (snapshot.hasData)
              ? (snapshot.data?.data ?? _viewModel.state)
              : _viewModel.state;

          _deviceState = (snapshot.hasData)
              ? (snapshot.data?.data ?? _deviceState)
              : _deviceState;

          print("Snapshot ${(snapshot.hasData) ? snapshot.data?.data : "null--"}");
          print("Device State is ${_deviceState?.deviceAddress}");

          final isConnected = !canConnect(_viewModel.state.deviceState);

          return ElevatedButton(
              onPressed: isConnected
                  ? () => _openOrderScreen()
                  : () => moniepointClient.connectToDevice(peerDevice.deviceAddress),
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor
                      .resolveWith((states) => isConnected
                      ? Colors.accentColor
                      : Colors.orange
                  )
              ),
              child: Text(
                isConnected ? "Manage Orders" : "Connect",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                ),
              )
          );
        }
    );
  }

}