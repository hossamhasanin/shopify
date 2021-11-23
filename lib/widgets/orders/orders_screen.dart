import 'package:flutter/material.dart';
import 'package:shopify/widgets/orders/components/orders_body.dart';
import 'package:shopify/widgets/utils/components/enums.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All orders"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              MenuStateHolder.stateHolder.value = MenuState.home;
            }),
      ),
      body: OrdersBody(),
    );
  }
}
