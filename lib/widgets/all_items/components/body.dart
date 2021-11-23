import 'package:all_items/all_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:shopify/widgets/app_bar/app_bar.dart';
import 'package:shopify/widgets/utils/helpers.dart';

import 'categories.dart';
import 'discount_banner.dart';
import '../../app_bar/home_header.dart';
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
    _controller = Get.find<AllItemsController>();
    _controller.getCats();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            HeaderAppBar(),
            GetX<AllItemsController>(
              init: _controller,
              builder: (controller) {
                var viewstate = controller.viewState.value;
                return Column(
                  children: [
                    SizedBox(height: getProportionateScreenWidth(10)),
                    DiscountBanner(),
                    viewstate!.loadingCats
                        ? Container(
                            child: Center(child: CircularProgressIndicator()))
                        : Categories(
                            categories: viewstate.cats,
                          ),
                    SizedBox(
                      height: 20.0,
                    ),
                    viewstate.loadingCats
                        ? Container(
                            child: Center(child: CircularProgressIndicator()))
                        : SpecialOffers(),
                    SizedBox(height: getProportionateScreenWidth(30)),
                    viewstate.error != null
                        ? Text(viewstate.error)
                        : SizedBox.shrink(),
                    viewstate.loading
                        ? Container(
                            child: Center(child: CircularProgressIndicator()))
                        : PopularProducts(
                            products: viewstate.popularItems,
                          ),
                    SizedBox(height: getProportionateScreenWidth(30)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
