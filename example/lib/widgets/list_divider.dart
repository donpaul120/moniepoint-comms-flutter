import 'package:flutter/material.dart' hide Colors;

import '../colors.dart';

class ListDivider extends StatelessWidget {
  const ListDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Divider(color: Colors.dividerColor, height: 1, thickness: 0.9),
    );
  }

}