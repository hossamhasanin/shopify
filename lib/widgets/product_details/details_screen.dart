import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";
  final Cart cart = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppBar(rating: cart.product.rating).build(context),
      body: Body(
        cart: cart,
      ),
    );
  }
}
