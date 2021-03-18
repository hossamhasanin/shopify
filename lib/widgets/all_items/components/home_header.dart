import 'package:all_items/all_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopify/widgets/all_items/components/search_field.dart';
import 'package:shopify/widgets/utils/helpers.dart';

import 'icon_btn_with_counter.dart';

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
          IconBtnWithCounter(
            svgSrc: "assets/icons/Cart Icon.svg",
            //press: () => Navigator.pushNamed(context, CartScreen.routeName),
            press: () {},
          ),
          GetBuilder<AllItemsController>(builder: (controller) {
            return IconBtnWithCounter(
              svgSrc: "assets/icons/Bell.svg",
              numOfitem: controller.viewState.value!.noNotifications,
              press: () {},
            );
          }),
        ],
      ),
    );
  }
}
