import 'package:comms_example/colors.dart';
import 'package:comms_example/core/app_route.dart';
import 'package:comms_example/main_view_model.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_pos_comms/peer_device.dart';
import 'package:moniepoint_pos_comms/peer_device_state.dart';
import 'package:moniepoint_pos_comms/protocol_data_event.dart';
import 'package:moniepoint_pos_comms/protocol_stream_extension.dart';
import 'package:provider/provider.dart';

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
    _dataStream = moniepointClient.protocolDataStream
        .filterForDeviceState(peerDevice.deviceAddress);
    super.initState();
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