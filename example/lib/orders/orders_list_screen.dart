
import 'package:comms_example/colors.dart';
import 'package:comms_example/orders/order_session_bottom_sheet.dart';
import 'package:comms_example/widgets/list_divider.dart';
import 'package:flutter/material.dart' hide Colors;

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OrderListScreen();
}

class _OrderListScreen extends State<OrderListScreen> {
  final defaultProductItems = [
    const Product(
        title: "Shampoo",
        amount: 2300.00,
        description: "Forever product"
    ),
    const Product(
        title: "Beverage",
        amount: 4500.90,
        description: "TeamApt Beverage Business product"
    ),
    const Product(
        title: "Karisma Jotter",
        amount: 100.21,
        description: "A very good jotter to take social media advisers notes"
    ),
    const Product(
        title: "TV/Fridge Guard Protector",
        amount: 13500.31,
        description: "Electronics shop. Product to help you prevent electronics items"
            " from blowing up"
    ),
    const Product(
        title: "Moniepoint Food Pack",
        amount: 243.57,
        description: "A very rich and affordable food"
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.dividerColor,
      body: ListView.separated(
        separatorBuilder: (ctx, index) => const ListDivider(),
        itemCount: defaultProductItems.length,
        itemBuilder: (ctx, index) {
          return _ProductListItem(product: defaultProductItems[index]);
        },
      ),
    );
  }

}

class _ProductListItem extends StatelessWidget {
  final Product product;

  const _ProductListItem({
    required this.product
  });

  TextStyle get _amountStyle => const TextStyle(
    fontSize: 16,
    color: Colors.primaryColor,
    fontWeight: FontWeight.w700
  );

  TextStyle get _descriptionStyle => const TextStyle(
      fontSize: 13,
      color: Colors.textColorBlack,
      fontWeight: FontWeight.w400
  );

  TextStyle get _titleStyle => const TextStyle(
      fontSize: 15,
      color: Colors.textColorBlack,
      fontWeight: FontWeight.w600
  );

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.title, style: _titleStyle),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: Text(product.description ?? "", style: _descriptionStyle)),
              const SizedBox(width: 4,),
              Text("N ${product.amount}", style: _amountStyle)
            ],
          )
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        overlayColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.5)),
        highlightColor: Colors.primaryColor.withOpacity(0.02),
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (ctx) => OrderSessionBottomSheet(product: product)
          );
        },
        child: child,
      ),
    );
  }
}

class Product {
  final String title;
  final double amount;
  final String? description;

  const Product({
    required this.title,
    required this.amount,
    this.description
  });
}