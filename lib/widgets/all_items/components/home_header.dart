import 'package:all_items/all_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopify/widgets/all_items/components/search_field.dart';
import 'package:shopify/widgets/utils/helpers.dart';

import 'icon_btn_with_counter.dart';

class HomeHeader extends StatelessWidget {
  int _noNotifications;
  HomeHeader({required int noNotifications})
      : this._noNotifications = noNotifications;
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
          IconBtnWithCounter(
            svgSrc: "assets/icons/Bell.svg",
            numOfitem: _noNotifications,
            press: () {},
          ),
        ],
      ),
    );
  }
}
