import 'package:flutter/cupertino.dart';
import 'package:orders/cancelOrderEventState.dart';
import 'package:orders/datasource.dart';
import 'package:orders/orderDetailViewState.dart';
import 'package:orders/ordersViewstate.dart';
import 'package:models/models.dart';

class OrdersUseCase {
  final OrdersDatasource _datasource;

  OrdersUseCase(this._datasource);

  Future<OrdersViewState> getOrders(
      OrdersViewState viewState, String lastOrder) async {
    try {
      var orders = await _datasource.getOrders(lastOrder);
      var allOrders = viewState.orders;
      allOrders.addAll(orders);
      return viewState.copy(loading: false, orders: allOrders, error: "");
    } catch (e) {
      debugPrint("koko " + e.toString());
      return viewState.copy(
          loading: false,
          error: "Somthing wrong with loading the orders",
          orders: []);
    }
  }

  Future<OrderDetailViewState> getOrderCarts(
      OrderDetailViewState viewState) async {
    try {
      var carts = await _datasource.getOrderdItems(viewState.order!.orderNum);
      debugPrint("carts " + carts.length.toString());
      return viewState.copy(carts: carts, loadingCarts: false, errorCarts: "");
    } catch (e) {
      return viewState.copy(
          carts: [],
          loadingCarts: false,
          errorCarts: "Error in loading the products");
    }
  }

  Future<List> cancelOrder(OrderDetailViewState viewState,
      CancelOrderEventState cancelOrderEventState) async {
    try {
      await _datasource.cancelOrder(viewState.order!);
      var order =
          viewState.order!.copy(orderState: OrderStates.Cancelled.index);

      return [
        viewState.copy(order: order),
        cancelOrderEventState.copy(loading: false, error: "", done: true)
      ];
    } catch (e) {
      return [
        viewState,
        cancelOrderEventState.copy(
            loading: false, error: "Somthing went wrong !", done: false)
      ];
    }
  }
}
