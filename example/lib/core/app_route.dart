
import 'package:comms_example/orders/orders_list_screen.dart';
import 'package:comms_example/orders/orders_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AppRoute {

  AppRoute._();

  static const orderListScreen = 'orderListScreen';

  static Map<String, WidgetBuilder> buildRouteMap() {
    return {
      orderListScreen: (context) => ChangeNotifierProvider(
        create: (_) => OrdersViewModel(),
        child: const OrderListScreen(),
      )
    };
  }
}