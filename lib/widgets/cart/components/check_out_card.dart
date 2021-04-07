import 'package:cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shopify/widgets/pay/payment_screen.dart';
import 'package:shopify/widgets/utils/components/default_button.dart';
import 'package:shopify/widgets/utils/helpers.dart';

import 'package:shopify/constants.dart';

class CheckoutCard extends StatelessWidget {
  double totalPrice;
  final CartController _controller = Get.find();
  final TextEditingController _voucherCodeController = TextEditingController();

  CheckoutCard({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.defaultDialog(
                    title: "Add voucher code",
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _voucherCodeController,
                            decoration: InputDecoration(
                                hintText: "Your code please ...",
                                border: UnderlineInputBorder()),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              Get.back();
                              _controller
                                  .useVoucher(_voucherCodeController.text);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                primary: kPrimaryColor),
                            child: Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ));
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    height: getProportionateScreenWidth(40),
                    width: getProportionateScreenWidth(40),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset("assets/icons/receipt.svg"),
                  ),
                  Spacer(),
                  Text("Add voucher code"),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: kTextColor,
                  )
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: "\$$totalPrice",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                    text: "Check Out",
                    press: () =>
                        Get.offNamed(PayMentScreen.routeName, arguments: [
                      _controller.viewState.value!.carts,
                      _controller.totalPrice.value!,
                      calcCartItems(),
                      _controller.viewState.value!.voucherCodes,
                    ]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
