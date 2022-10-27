import 'package:comms/peer_device.dart';
import 'package:comms/protocol_data_event.dart';
import 'package:flutter/material.dart';

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
      title: 'Moniepoint Protocol Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Demo'),
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

  @override
  void initState() {
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
          print("Data Snap => $snapshot");
          if (snapshot.connectionState != ConnectionState.active || !snapshot.hasData) {
            return const SizedBox.shrink();
          }
          final data = snapshot.data as ProtocolEvent<List<PeerDevice>>;
          return ListView(
            children: data.data?.map((e) => DeviceListTile(device: e)).toList() ?? [],
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              device.deviceName,
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.amberAccent)
                ),
                onPressed: () {
                  //Attempt to connect to device
                  IMoniepointProtocolData.getInstance()
                      .connectToDevice(device.deviceAddress);
                },
                child: const Text(
                    "Connect",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    ),
                )
            )
          ],
        ),
    );
  }

}
