import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:shopify/constants.dart';
import 'package:shopify/datasources/database/FirebaseDataSource.dart';
import 'package:shopify/widgets/cat_items/cat_items_screen.dart';
import 'package:shopify/widgets/utils/components/default_button.dart';
import 'package:shopify/widgets/utils/helpers.dart';
import 'color_dots.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';
import 'package:product_details/product_details.dart';

class Body extends StatefulWidget {
  late final productInCartCondition;
  final Cart cart;
  ProductDetailsController? _controller;

  Body({required this.cart}) {
    productInCartCondition = Cart.carts.contains(cart);
    this._controller = Get.put(ProductDetailsController(
        networkDataSource: Get.find<FirebaseDataSource>(),
        product: cart.product,
        numOfItem: cart.numOfItem,
        selectedColor: cart.selectedColor,
        isNew: Cart.carts.contains(cart)));
  }

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    widget._controller!.viewState.stream.distinct().listen((state) {
      if (state!.addToCartDone) {
        Get.snackbar("Done .", "Your product is added successfuly .");
      } else if (state.addingToCart) {
        Get.snackbar("Wait ...", "wait a bit ...", showProgressIndicator: true);
      } else if (state.errorInCart.isNotEmpty) {
        Get.snackbar("Error !", state.errorInCart,
            backgroundColor: Colors.red.withOpacity(0.4));
      } else if (state.removeFromCartDone) {
        Get.snackbar("Done .", "Your product is removed successfuly .");
      } else if (state.removingFromCart) {
        Get.snackbar("Wait ...", "wait a bit ...", showProgressIndicator: true);
      } else if (state.editCartDone) {
        Get.snackbar("Done .", "Your product is edited successfuly .");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(product: widget.cart.product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: widget.cart.product,
                pressOnSeeMore: () {},
              ),
              GetX<ProductDetailsController>(
                init: widget._controller,
                builder: (controller) => TopRoundedContainer(
                  color: Color(0xFFF6F7F9),
                  child: Column(
                    children: [
                      ColorDots(
                        numOfItem: controller.viewState.value!.numOfItem,
                        product: widget.cart.product,
                        selectedColor:
                            controller.viewState.value!.selectedColor,
                        addItem: () {
                          controller.addItem();
                        },
                        removeItem: () {
                          controller.removeItem();
                        },
                        selectColor: (color) {
                          controller.selectColor(color);
                        },
                      ),
                      TopRoundedContainer(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.screenWidth * 0.15,
                            right: SizeConfig.screenWidth * 0.15,
                            bottom: getProportionateScreenWidth(40),
                            top: getProportionateScreenWidth(15),
                          ),
                          child: DefaultButton(
                            text: Cart.carts.indexWhere((cart) =>
                                        cart.product.id ==
                                        controller
                                            .viewState.value!.product.id) >
                                    -1
                                ? "Remove from cart"
                                : "Add To Cart",
                            color: Cart.carts.indexWhere((cart) =>
                                        cart.product.id ==
                                        controller
                                            .viewState.value!.product.id) >
                                    -1
                                ? Colors.grey.shade500
                                : kPrimaryColor,
                            press: () {
                              if (Cart.carts.indexWhere((cart) =>
                                      cart.product.id ==
                                      controller.viewState.value!.product.id) >
                                  -1)
                                controller.removeFromCart();
                              else
                                controller.addToCart();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
