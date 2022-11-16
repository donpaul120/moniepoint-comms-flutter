import 'dart:async';
import 'dart:math';

import 'package:comms_example/colors.dart';
import 'package:moniepoint_pos_comms/protocol_data_response.dart';
import 'package:moniepoint_pos_comms/protocol_stream_extension.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_pos_comms/protocol_data_event.dart';
import 'package:moniepoint_pos_comms/protocol_data_request.dart';

import 'orders_list_screen.dart';

class OrderSessionBottomSheet extends StatefulWidget {
  const OrderSessionBottomSheet({
    required this.product,
    super.key
  });

  final Product product;

  @override
  State<StatefulWidget> createState() => _OrderSessionBottomSheet();

}

class _OrderSessionBottomSheet extends State<OrderSessionBottomSheet> {

  late final IMoniepointProtocolData moniepointClient;
  late final Product product;
  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rand = Random();
  late final String refNumber = generateReference;
  StreamSubscription<ProtocolEvent>? _sessionSubscription;

  @override
  void initState() {
    moniepointClient = IMoniepointProtocolData.getInstance();
    product = widget.product;
    super.initState();
  }

  String get generateReference {
    return String.fromCharCodes(Iterable.generate(
        10, (_) => _chars.codeUnitAt(_rand.nextInt(_chars.length)))
    );
  }

  void _listenForOrderResponse(ProtocolDataRequest request) {
    _sessionSubscription?.cancel();

    _sessionSubscription = moniepointClient.protocolDataStream
        .filterBySessionResponse()
        .listen((event) {
          switch (event.eventType) {
            case ProtocolEventType.orderResponse:
              {
                moniepointClient.sendEndOfText();
                final response = event.data as ProtocolDataResponse?;
                print("ResponseFromPOS: ${response?.toString()}");
                break;
              }
            case ProtocolEventType.cancelData:
              //The POS has prolly cancelled the transaction
              break;
            case ProtocolEventType.invalidData:
              //We prolly sent an invalid data
              break;
            case ProtocolEventType.acknowledged:
              moniepointClient.sendRequest(request);
              break;
            default:
              break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          product.title,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.textColorBlack
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            product.description ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.textColorBlack),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        const Text(
          "Generated Reference Number",
          style: TextStyle(
              color: Colors.textColorBlack,
              fontSize: 14
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
            refNumber,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black
            )
        ),
        const SizedBox(
          height: 24,
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.accentColor)),
            onPressed: () {
              final request = ProtocolDataRequest(
                  refNumber: refNumber, amount: product.amount
              );
              _listenForOrderResponse(request);
              moniepointClient.startRequestOrderSession();
            },
            child: const Text(
              "Proceed",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            )),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16)
          ),
          color: Colors.white
      ),
      child: Wrap(
        children: [
          child
        ],
      ),
    );
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    super.dispose();
  }
}