import 'package:cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:shopify/widgets/utils/helpers.dart';

import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
      bottomNavigationBar: GetX<CartController>(builder: (controller) {
        return CheckoutCard(
          totalPrice: controller.totalPrice.value!,
        );
      }),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
          Obx(() {
            return Text(
              "${calcCartItems()} items",
              style: Theme.of(context).textTheme.caption,
            );
          }),
        ],
      ),
    );
  }
}
