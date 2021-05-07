import 'dart:async';

import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:orders/cancelOrderEventState.dart';
import 'package:orders/datasource.dart';
import 'package:orders/events/cancel_order.dart';
import 'package:orders/events/get_carts.dart';
import 'package:orders/events/get_orders.dart';
import 'package:orders/events/orders_event.dart';
import 'package:orders/orderDetailViewState.dart';
import 'package:orders/ordersViewstate.dart';
import 'package:orders/usecase.dart';

class OrdersController extends GetxController {
  final Rx<OrdersViewState> ordersViewstate =
      OrdersViewState(orders: [], loading: false, error: "").obs;

  final Rx<OrderDetailViewState> orderDetailViewState = OrderDetailViewState(
          carts: [], loadingCarts: false, errorCarts: "", order: null)
      .obs;

  final Rx<CancelOrderEventState> cancelEventState =
      CancelOrderEventState(loading: false, error: "", done: false).obs;

  late OrdersUseCase _useCase;

  StreamController<OrdersEvent> _eventHandler = StreamController();

  OrdersController({required OrdersDatasource datasource}) {
    _useCase = OrdersUseCase(datasource);

    _eventHandler.stream.listen((event) {
      if (event is GetOrders) {
        _getOrders(event);
      } else if (event is GetCarts) {
        _getCarts(event);
      } else if (event is CancelOrder) {
        _cancelOrder(event);
      }
    });
  }

  getOrders(String lastOrder) {
    if (ordersViewstate.value!.loading) return;
    ordersViewstate.value =
        ordersViewstate.value!.copy(loading: true, error: "");
    _eventHandler.sink.add(GetOrders(lastOrder: lastOrder));
  }

  getCarts() {
    if (orderDetailViewState.value!.loadingCarts) return;
    orderDetailViewState.value =
        orderDetailViewState.value!.copy(loadingCarts: true);
    _eventHandler.sink
        .add(GetCarts(orderId: orderDetailViewState.value!.order!.orderNum));
  }

  cancelOrder() {
    if (cancelEventState.value!.loading) return;
    cancelEventState.value =
        cancelEventState.value!.copy(loading: true, error: "");
    _eventHandler.sink
        .add(CancelOrder(orderId: orderDetailViewState.value!.order!.orderNum));
  }

  setOrderInOrderDetail(Order order) {
    orderDetailViewState.value = orderDetailViewState.value!.copy(order: order);
  }

  _getOrders(GetOrders event) async {
    ordersViewstate.value =
        await _useCase.getOrders(ordersViewstate.value!, event.lastOrder);
  }

  _getCarts(GetCarts event) async {
    orderDetailViewState.value =
        await _useCase.getOrderCarts(orderDetailViewState.value!);
  }

  _cancelOrder(CancelOrder event) async {
    var result = await _useCase.cancelOrder(
        orderDetailViewState.value!, cancelEventState.value!);

    orderDetailViewState.value = result[0];
    cancelEventState.value = result[1];
  }

  @override
  void onClose() {
    ordersViewstate.close();
    _eventHandler.close();
    cancelEventState.close();
    super.onClose();
  }
}
