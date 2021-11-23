import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:shopify/widgets/pay/components/address_item.dart';
import 'package:shopify/widgets/pay/components/put_address_screen.dart';
import 'package:shopify/widgets/pay/components/text_field.dart';
import 'package:shopify/widgets/utils/components/default_button.dart';
import 'package:shopify/widgets/utils/helpers.dart';

import 'package:pay/pay.dart';

class ShippingDetailsScreen extends StatelessWidget {
  PageController _pageController;
  final PayController _controller = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  ShippingDetailsScreen({required PageController pageController})
      : this._pageController = pageController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("Full officail name :",
              style: TextStyle(color: Colors.black)),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        CustomedTextField(
          hintText: "Please write the full officail name",
          textEditingController: nameController,
          textInputType: TextInputType.text,
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("Mobile number :", style: TextStyle(color: Colors.black)),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        CustomedTextField(
          hintText: "We would use mobile number to contact you about the order",
          textEditingController: mobileNumberController,
          textInputType: TextInputType.phone,
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Pick an adress :",
                  style: TextStyle(color: Colors.black)),
            ),
            TextButton(
                onPressed: () async {
                  Address address =
                      await Get.toNamed(PutAddressScreen.routeName);
                  _controller.addAddress(address);
                },
                child: Text(
                  "Add new",
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        ),
        Container(
          height: 200.0,
          child: GetX<PayController>(builder: (controller) {
            var viewstate = controller.viewstate.value!;
            debugPrint("addresses " + viewstate.addresses.length.toString());
            if (viewstate.loadingAddresses) {
              return Center(child: CircularProgressIndicator());
            }

            if (viewstate.errLoadingAddresses.isNotEmpty) {
              return Center(
                  child: Text(viewstate.errLoadingAddresses,
                      style: TextStyle(color: Colors.grey)));
            }

            if (viewstate.addresses.isEmpty) {
              return Center(
                  child: Text("You have no saved address .",
                      style: TextStyle(color: Colors.grey)));
            } else {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return AddressItem(
                    key: ValueKey(viewstate.addresses[index].toString()),
                    address: viewstate.addresses[index],
                    groupValue: viewstate.curAddress,
                    setGroupValue: (address) {
                      controller.viewstate.value =
                          viewstate.copy(curAddress: address);
                    },
                  );
                },
                itemCount: viewstate.addresses.length,
              );
            }
          }),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        Center(
            child: DefaultButton(
                text: "Next",
                press: () {
                  _controller.viewstate.value = _controller.viewstate.value!
                      .copy(
                          fullName: nameController.text,
                          phone: mobileNumberController.text);

                  _pageController.animateToPage(1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.bounceIn);
                }))
      ],
    );
  }
}
