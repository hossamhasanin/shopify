import 'package:cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shopify/widgets/product_details/details_screen.dart';
import 'package:shopify/widgets/utils/helpers.dart';
import 'cart_card.dart';
import 'package:models/cart.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late CartController _controller;

  @override
  void initState() {
    super.initState();

    _controller = Get.find();
    _controller.getCarts();

    _controller.eventstate.stream.distinct().listen((state) {
      if (state!.done) {
        Get.snackbar("Done .", "Removed successfuly .");
      } else if (state.error.isNotEmpty) {
        Get.snackbar("Error !", state.error,
            backgroundColor: Colors.red.withOpacity(0.4));
      }
    });
    _controller.viewState.stream.distinct().listen((state) {
      if (state!.voucherCodes.isNotEmpty) {
        Get.defaultDialog(
            title: "Voucher code " + state.voucherCodes.last.title,
            middleText: "Applied successfuly");
      } else if (state.errorCode.isNotEmpty) {
        Get.defaultDialog(
            title: "Error !",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  state.errorCode,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ));
      } else if (state.loadingCode) {
        Get.defaultDialog(
            title: "Wait a bit ...",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5.0,
                ),
                CircularProgressIndicator()
              ],
            ),
            barrierDismissible: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: GetX<CartController>(
        init: _controller,
        builder: (controller) {
          var viewstate = controller.viewState.value!;
          if (viewstate.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (viewstate.error.isNotEmpty) {
            return Center(child: Text(viewstate.error));
          } else if (viewstate.carts.isNotEmpty) {
            return buildCartList(viewstate.carts, (id) {
              controller.removeProduct(id);
            });
          } else {
            return Container();
          }
        },
      ),
    );
  }

  ListView buildCartList(List<Cart> carts, Function(String) remove) {
    return ListView.builder(
      itemCount: carts.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () =>
              Get.offNamed(DetailsScreen.routeName, arguments: carts[index]),
          child: Dismissible(
            key: Key(carts[index].product.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              remove(carts[index].product.id);
            },
            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Spacer(),
                  SvgPicture.asset("assets/icons/Trash.svg"),
                ],
              ),
            ),
            child: CartCard(
              cart: carts[index],
              key: ValueKey(carts[index]),
            ),
          ),
        ),
      ),
    );
  }
}
