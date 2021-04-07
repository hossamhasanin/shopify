import 'package:flutter/material.dart';
import 'package:flutter_fawry_pay/flutter_fawry_pay.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:shopify/datasources/database/FirebaseDataSource.dart';
import 'package:shopify/widgets/pay/components/order_status_screen.dart';
import 'package:shopify/widgets/pay/components/payment_method_screen.dart';
import 'package:shopify/widgets/pay/components/shipping_details_screen.dart';
import 'package:shopify/widgets/pay/components/timeline.dart';
import 'package:pay/pay.dart';

class PayMentScreen extends StatefulWidget {
  static String routeName = "/pay_screen";
  @override
  _PayMentScreenState createState() => _PayMentScreenState();
}

class _PayMentScreenState extends State<PayMentScreen> {
  late final PayController _controller;
  late final PageController _pageController;

  List args = Get.arguments;

  @override
  void initState() {
    super.initState();

    _controller = Get.put(PayController(
        datasource: Get.find<FirebaseDataSource>(),
        carts: args[0],
        totalPrice: args[1],
        numAllItems: args[2],
        voucherCodes: args[3]))!;
    _pageController = PageController();

    _controller.getAddresses();
    _controller.viewstate.value!.orderEventState.stream
        .distinct()
        .listen((orderEvent) {
      if (orderEvent!.loading) {
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
      if (orderEvent.sucessed) {
        Get.back();
        _pageController.animateToPage(2,
            duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
      }
      if (orderEvent.error.isNotEmpty) {
        Get.back();
        Get.defaultDialog(
            title: "Error !",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  orderEvent.error,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller.processIndex.value == 1) {
          _pageController.animateToPage(0,
              duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Set your order"),
          ),
          body: Column(
            children: [
              GetX<PayController>(builder: (controller) {
                var pi = controller.processIndex.value;
                debugPrint("here page " + pi.toString());
                return Expanded(
                  flex: 2,
                  child: ProcessTimeline(
                    processIndex: pi,
                    processes: controller.processes,
                  ),
                );
              }),
              Expanded(
                flex: 10,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ShippingDetailsScreen(
                        pageController: _pageController,
                      ),
                      PaymentMethodScreen(
                        pageController: _pageController,
                      ),
                      OrderStatusScreen(
                        controller: _pageController,
                      )
                    ],
                    onPageChanged: (index) {
                      debugPrint("move to " + index.toString());
                      _controller.move(index);
                    },
                  ),
                ),
              )
            ],
          )),
    );
  }
}
