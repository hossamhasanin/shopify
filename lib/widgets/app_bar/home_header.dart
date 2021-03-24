import 'package:app_bar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:shopify/widgets/all_items/components/search_field.dart';
import 'package:shopify/widgets/cart/cart_screen.dart';
import 'package:shopify/widgets/utils/helpers.dart';

import '../all_items/components/icon_btn_with_counter.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(),
          Obx(() {
            debugPrint("cart count " + Cart.carts.length.toString());
            return IconBtnWithCounter(
              svgSrc: "assets/icons/Cart Icon.svg",
              press: () => Get.toNamed(CartScreen.routeName),
              numOfitem: Cart.carts.length,
            );
          }),
          GetX<AppBarController>(builder: (controller) {
            return IconBtnWithCounter(
              svgSrc: "assets/icons/Bell.svg",
              numOfitem: controller.noNotifications.value,
              press: () {},
            );
          }),
        ],
      ),
    );
  }
}
