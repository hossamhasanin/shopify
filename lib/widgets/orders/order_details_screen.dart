import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:orders/ordersController.dart';
import 'package:shopify/constants.dart';
import 'package:shopify/datasources/database/FirebaseDataSource.dart';
import 'package:shopify/widgets/cart/components/cart_card.dart';
import 'package:shopify/widgets/orders/components/order_timeline.dart';
import 'package:shopify/widgets/utils/components/enums.dart';
import 'package:shopify/widgets/utils/helpers.dart';

class OrderDetailsScreen extends StatefulWidget {
  static String routeName = "/order_details";

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Order _order = Get.arguments;

  late OrdersController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        Get.put(OrdersController(datasource: Get.find<FirebaseDataSource>()))!;

    _controller.setOrderInOrderDetail(_order);
    _controller.getCarts();

    _controller.cancelEventState.stream.distinct().listen((state) {
      if (state!.loading) {
        Get.snackbar("Wait ...", "Cancelling the order");
      } else if (state.error.isNotEmpty) {
        Get.snackbar("Error", state.error);
      } else if (state.done) {
        Get.snackbar("Cancelled", "Order cancelled successfully");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All orders",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kPrimaryColor,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              MenuStateHolder.stateHolder.value = MenuState.home;
            }),
      ),
      body: ListView(
        children: [
          Container(
            height: 100.0,
            child: GetX<OrdersController>(builder: (controller) {
              var viewstate = controller.orderDetailViewState.value!;
              var orderStates =
                  viewstate.order!.orderState == OrderStates.Cancelled.index
                      ? <OrderStates>[
                          OrderStates.Ordered,
                          OrderStates.Shipping,
                          OrderStates.Cancelled
                        ]
                      : <OrderStates>[
                          OrderStates.Ordered,
                          OrderStates.Shipping,
                          OrderStates.Delevired
                        ];
              return OrderTimeline(
                  processIndex: viewstate.order!.orderState,
                  processes: orderStates);
            }),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          _buildOrderInfo(),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          Divider(
            thickness: 1.0,
            indent: 20.0,
            endIndent: 20.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 10.0),
            child: Text(
              "Products :",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          GetX<OrdersController>(builder: (controller) {
            var viewstate = controller.orderDetailViewState.value!;
            if (viewstate.loadingCarts) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (viewstate.errorCarts.isNotEmpty) {
              return Center(child: Text(viewstate.errorCarts));
            } else if (viewstate.carts.isNotEmpty) {
              return _buildCartList(viewstate.carts);
            } else {
              return Center(
                child: Text("Error with cart items"),
              );
            }
          }),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Obx(() {
              var orderState =
                  _controller.orderDetailViewState.value!.order!.orderState;
              return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: orderState != OrderStates.Cancelled.index
                          ? Colors.red
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0))),
                  onPressed: () {
                    if (_controller
                            .orderDetailViewState.value!.order!.orderState ==
                        OrderStates.Cancelled.index) {
                      Get.snackbar("Nope",
                          "You cann't bro cancel somthing already canceled");
                      return;
                    }
                    _controller.cancelOrder();
                  },
                  icon: Icon(Icons.cancel_presentation_rounded),
                  label: Text("Cancel order"));
            }),
          )
        ],
      ),
    );
  }

  Widget _buildCartList(List<Cart> carts) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var cart = carts[index];
          return CartCard(key: ValueKey(cart.product.id), cart: cart);
        },
        itemCount: carts.length,
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: [
          _buildTextItem("Order number :", _order.orderNum),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          _buildTextItem("Officail owner name :", _order.officialName),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          _buildTextItem("Total price :", _order.totalPrice.toString()),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          _buildTextItem("Address :", _order.address),
        ],
      ),
    );
  }

  Widget _buildTextItem(String text1, String text2) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 10.0),
      child: Row(
        children: [
          Text(
            text1,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(10),
          ),
          Expanded(
            child: Text(text2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
