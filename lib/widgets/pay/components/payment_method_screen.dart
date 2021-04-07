import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:pay/pay.dart';
import 'package:shopify/widgets/pay/components/payment_card.dart';
import 'package:shopify/widgets/utils/components/default_button.dart';
import 'package:shopify/widgets/utils/helpers.dart';

class PaymentMethodScreen extends StatelessWidget {
  PageController _pageController;
  PayController _controller = Get.find();
  PaymentMethodScreen({required PageController pageController})
      : this._pageController = pageController;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.payment_rounded),
                    SizedBox(height: getProportionateScreenWidth(10)),
                    Text(
                      "How do you wanna pay ?",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Expanded(child: GetX<PayController>(builder: (controller) {
                var viewstate = controller.viewstate.value!;
                var groupValue = PaymentEnum.values.firstWhere(
                    (element) => element.toString() == viewstate.paymentMethod,
                    orElse: () => PaymentEnum.PayOnDeleviry);
                return ListView(
                  children: [
                    PaymentCard(
                        value: PaymentEnum.PayOnDeleviry,
                        groupValue: groupValue,
                        onChanged: (value) {
                          controller.viewstate.value =
                              viewstate.copy(paymentMethod: value.toString());
                          debugPrint("pay method " +
                              controller.viewstate.value!.paymentMethod);
                        })
                  ],
                );
              })),
            ],
          ),
        ),
        DefaultButton(
            text: "Confirm",
            press: () {
              _controller.addOrder();
            })
      ],
    );
  }
}
