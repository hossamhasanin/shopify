import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/address.dart';
import 'package:pay/controller.dart';
import 'package:pay/pay.dart';
import 'package:shopify/constants.dart';
import 'package:shopify/widgets/pay/components/text_field.dart';
import 'package:shopify/widgets/utils/components/default_button.dart';
import 'package:shopify/widgets/utils/helpers.dart';

class PutAddressScreen extends GetView<PutAddressController> {
  static String routeName = "/put_address_screen";
  final Address _address = Get.arguments ??
      Address(id: "", street: "", city: "", governorate: "", optionalInfo: "");

  final TextEditingController addressController = TextEditingController();

  final TextEditingController moreInfoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(PutAddressController(setAddress: _address));

    addressController.text = controller.address.value!.street;
    moreInfoController.text = controller.address.value!.optionalInfo;
    controller.setGovs();
    if (controller.address.value!.city.isNotEmpty) {
      debugPrint("test " + controller.address.value!.governorate);
      controller.setCities(controller.address.value!.governorate);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add new address",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              Text("* Address street :", style: TextStyle(color: Colors.black)),
              SizedBox(height: getProportionateScreenHeight(10)),
              CustomedTextField(
                hintText: "Please write your detailed address street ...",
                textEditingController: addressController,
                textInputType: TextInputType.text,
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Text("More info about the address :",
                  style: TextStyle(color: Colors.black)),
              SizedBox(height: getProportionateScreenHeight(10)),
              CustomedTextField(
                hintText:
                    "If there is any more informations about the address ...",
                textEditingController: moreInfoController,
                textInputType: TextInputType.text,
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("* Governorate :",
                            style: TextStyle(color: Colors.black)),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: buildGovs(),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("* City :", style: TextStyle(color: Colors.black)),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: buildCities(),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              Center(
                  child: DefaultButton(
                      text: "Done",
                      press: () {
                        controller.address.value = controller.address.value!
                            .copy(
                                street: addressController.text,
                                optionalInfo: moreInfoController.text);
                        Get.back(result: controller.address.value!);
                      }))
            ],
          ),
        ));
  }

  GetX<PutAddressController> buildCities() {
    return GetX<PutAddressController>(builder: (controller) {
      var address = controller.address.value!;
      var cities = controller.cities;

      debugPrint("widget cities " + cities.toString());
      return DropdownButton<String>(
        value:
            address.city.isNotEmpty && cities.isNotEmpty ? address.city : null,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 42,
        style: const TextStyle(color: Colors.black),
        underline: SizedBox(),
        onChanged: (String? city) {
          if (city != null) {
            controller.address.value = address.copy(city: city);
          }
        },
        items: cities.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }

  GetX<PutAddressController> buildGovs() {
    return GetX<PutAddressController>(builder: (controller) {
      var address = controller.address.value!;
      var govs = controller.govs;
      return DropdownButton<String>(
        value: address.governorate.isNotEmpty && govs.isNotEmpty
            ? address.governorate
            : null,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 42,
        style: const TextStyle(color: Colors.black),
        underline: SizedBox(),
        onChanged: (String? govornorate) {
          if (govornorate != null) {
            controller.address.value =
                address.copy(governorate: govornorate, city: "");
            controller.setCities(govornorate);
          }
        },
        items: govs.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }
}
