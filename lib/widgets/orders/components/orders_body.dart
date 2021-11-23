import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:orders/ordersController.dart';
import 'package:shopify/constants.dart';
import 'package:shopify/datasources/database/FirebaseDataSource.dart';
import 'package:shopify/widgets/orders/order_details_screen.dart';
import 'package:shopify/widgets/utils/helpers.dart';

class OrdersBody extends StatefulWidget {
  @override
  _OrdersBodyState createState() => _OrdersBodyState();
}

class _OrdersBodyState extends State<OrdersBody> {
  late OrdersController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller =
        Get.put(OrdersController(datasource: Get.find<FirebaseDataSource>()))!;

    _controller.getOrders("");
  }

  @override
  Widget build(BuildContext context) {
    return GetX<OrdersController>(builder: (controller) {
      var viewstate = controller.ordersViewstate.value!;
      debugPrint("orders " + viewstate.orders.toString());
      if (viewstate.loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (viewstate.error.isNotEmpty) {
        return Center(child: Text(viewstate.error));
      } else if (viewstate.orders.isNotEmpty) {
        return _buildOrdersList(viewstate.orders);
      } else {
        return Center(
          child: Text("You haven't order anything"),
        );
      }
    });
  }

  Widget _buildOrdersList(List<Order> orders) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
      itemCount: orders.length,
    );
  }

  Widget _buildOrderCard(Order order) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(OrderDetailsScreen.routeName, arguments: order);
      },
      child: Card(
        color: Colors.white,
        elevation: 10.0,
        margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: kPrimaryColor, width: 2.0)),
        child: Hero(
          tag: order,
          child: Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Column(
              children: [
                _buildTextItem("Order number :", order.orderNum),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                _buildTextItem("Officail owner name :", order.officialName),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                _buildTextItem("Total price :", order.totalPrice.toString()),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                _buildTextItem("Address :", order.address),
              ],
            ),
          ),
        ),
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
