import 'package:all_items/all_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:shopify/widgets/utils/helpers.dart';

import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'special_offers.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late AllItemsController _controller;
  @override
  void initState() {
    super.initState();
    _controller = Get.find();
    _controller.getCats();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Obx(
          () {
            return Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                HomeHeader(),
                SizedBox(height: getProportionateScreenWidth(10)),
                DiscountBanner(),
                _controller.viewState.value!.loadingCats
                    ? Container(
                        child: Center(child: CircularProgressIndicator()))
                    : Categories(
                        categories: _controller.viewState.value!.cats,
                      ),
                SizedBox(
                  height: 20.0,
                ),
                _controller.viewState.value!.loadingCats
                    ? Container(
                        child: Center(child: CircularProgressIndicator()))
                    : SpecialOffers(),
                SizedBox(height: getProportionateScreenWidth(30)),
                _controller.viewState.value!.error != null
                    ? Center(child: Text(_controller.viewState.value!.error))
                    : SizedBox.shrink(),
                _controller.viewState.value!.loading
                    ? Container(
                        child: Center(child: CircularProgressIndicator()))
                    : PopularProducts(
                        products: _controller.viewState.value!.popularItems,
                      ),
                SizedBox(height: getProportionateScreenWidth(30)),
              ],
            );
          },
        ),
      ),
    );
  }
}
