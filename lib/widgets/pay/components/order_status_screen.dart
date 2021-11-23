import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopify/widgets/all_items/AllItemsScreen.dart';
import 'package:shopify/widgets/utils/components/default_button.dart';
import 'package:shopify/widgets/utils/helpers.dart';

class OrderStatusScreen extends StatelessWidget {
  PageController _controller;
  OrderStatusScreen({required PageController controller})
      : this._controller = controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: SizeConfig.screenHeight * 0.4, //40%
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Text(
          "Order has been set successfuly",
          style: TextStyle(
              fontSize: getProportionateScreenWidth(22),
              fontWeight: FontWeight.bold,
              color: Colors.black),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: "Back to home",
            press: () {
              Get.back();
            },
          ),
        ),
        Spacer(),
      ],
    );
  }
}
