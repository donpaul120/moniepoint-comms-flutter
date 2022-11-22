
import 'package:comms_example/core/app_route.dart';
import 'package:comms_example/main_view_model.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_pos_comms/peer_device.dart';
import 'package:moniepoint_pos_comms/protocol_data_event.dart';
import 'package:provider/provider.dart';

import 'colors.dart';
import 'widgets/connect_button.dart';

/// @author Paul Okeke
/// Moniepoint X TeamApt

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moniepoint Protocol TestApp',
      theme: ThemeData(primaryColor: Colors.primaryColor),
      home: ChangeNotifierProvider(
        create: (_) => MainViewModel(),
        child: const MyHomePage(title: 'Peer Devices'),
      ),
      routes: AppRoute.buildRouteMap(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late final IMoniepointProtocolData client;
  late final MainViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<MainViewModel>(context, listen: false);
    client = IMoniepointProtocolData.getInstance().initialize();
    super.initState();
    client.listenForDevicePeers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: client.protocolDataStream
            .where((event) => event.eventType == ProtocolEventType.deviceList),
        builder: (ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.active || !snapshot.hasData) {
            return const SizedBox.shrink();
          }
          final data = snapshot.data as ProtocolEvent<List<PeerDevice>>;
          final listItems = data.data ?? [];
          return ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (_, index) => ChangeNotifierProvider.value(
                value: _viewModel,
                child: DeviceListTile(device: listItems[index]),
              ),
              separatorBuilder: (ctx, index) => const SizedBox.shrink(),
              itemCount: listItems.length
          );
        },
      ),
    );
  }
}

class DeviceListTile extends StatelessWidget {
  const DeviceListTile({required this.device, super.key});

  final PeerDevice device;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              device.deviceName,
              style: const TextStyle(
                  color: Colors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
              ),
            ),
            ConnectButton(peerDevice: device)
          ],
        ),
    );
  }

}
