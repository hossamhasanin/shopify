import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";
  final Product _product = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppBar(rating: _product.rating).build(context),
      body: Body(product: _product),
    );
  }
}
