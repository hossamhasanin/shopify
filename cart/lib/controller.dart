import 'dart:async';

import 'package:cart/datasource.dart';
import 'package:cart/events/cart_event.dart';
import 'package:cart/events/get_carts.dart';
import 'package:cart/events/remove_product.dart';
import 'package:cart/eventstate.dart';
import 'package:cart/usecase.dart';
import 'package:cart/viewstate.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class CartController extends GetxController {
  final Rx<CartViewState> viewState =
      CartViewState(carts: List.empty(), loading: false, error: "").obs;

  RxInt numOfAllItems = 0.obs;
  RxDouble totalPrice = 0.0.obs;

  final Rx<EventState> eventstate =
      EventState(removeDone: false, removeError: "").obs;
  late CartUseCase _useCase;
  StreamController<CartEvent> _eventHandller = StreamController();

  CartController({required CartDataSource dataSource}) {
    _useCase = CartUseCase(dataSource: dataSource);

    _eventHandller.stream.listen((event) {
      if (event is GetCarts) {
        _getCarts();
      } else if (event is RemoveProduct) {
        _removeProduct(event);
      }
    });
  }

  getCarts() {
    _eventHandller.sink.add(GetCarts());
  }

  removeProduct(String id) {
    _eventHandller.sink.add(RemoveProduct(id: id));
  }

  _removeProduct(RemoveProduct event) async {
    Cart cart = viewState.value!.carts
        .singleWhere((cart) => cart.product.id == event.id);

    eventstate.value =
        await _useCase.removeProduct(event.id, eventstate.value!);

    viewState.value = viewState.value!.copy(carts: Cart.carts);
    var numItems = numOfAllItems.value;
    var price = totalPrice.value!;
    numItems -= cart.numOfItem;
    price -= cart.numOfItem * cart.product.price;

    numOfAllItems.value = numItems;
    totalPrice.value = price;
  }

  _getCarts() async {
    var result = await _useCase.getCarts(viewState.value!);
    viewState.value = result[0];
    numOfAllItems.value = result[1];
    totalPrice.value = result[2];
  }

  @override
  void onClose() {
    viewState.close();
    _eventHandller.close();
    super.onClose();
  }
}
