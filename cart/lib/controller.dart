import 'dart:async';

import 'package:cart/datasource.dart';
import 'package:cart/events/cart_event.dart';
import 'package:cart/events/get_carts.dart';
import 'package:cart/events/remove_product.dart';
import 'package:cart/events/use_voucher_code.dart';
import 'package:cart/eventstate.dart';
import 'package:cart/usecase.dart';
import 'package:cart/viewstate.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class CartController extends GetxController {
  final Rx<CartViewState> viewState = CartViewState(
      carts: List.empty(),
      loading: false,
      error: "",
      errorCode: "",
      loadingCode: false,
      voucherCodes: []).obs;

  // RxInt numOfAllItems = 0.obs;
  RxDouble totalPrice = 0.0.obs;

  final Rx<EventState> eventstate = EventState(done: false, error: "").obs;
  late CartUseCase _useCase;
  StreamController<CartEvent> _eventHandller = StreamController();

  CartController({required CartDataSource dataSource}) {
    _useCase = CartUseCase(dataSource: dataSource);

    _eventHandller.stream.listen((event) {
      if (event is GetCarts) {
        _getCarts();
      } else if (event is RemoveProduct) {
        _removeProduct(event);
      } else if (event is UseVoucherCode) {
        _useGetVoucher(event);
      }
    });
  }

  getCarts() {
    _eventHandller.sink.add(GetCarts());
  }

  removeProduct(String id) {
    _eventHandller.sink.add(RemoveProduct(id: id));
  }

  useVoucher(String code) {
    if (viewState.value!.loading || viewState.value!.error.isNotEmpty) return;
    _eventHandller.sink.add(UseVoucherCode(code: code));
  }

  _removeProduct(RemoveProduct event) async {
    eventstate.value =
        await _useCase.removeProduct(event.id, eventstate.value!);

    viewState.value = viewState.value!.copy(carts: Cart.carts);
    var price = totalPrice.value!;

    viewState.value!.voucherCodes.forEach((code) {
      totalPrice.value =
          _useCase.calculatePrice(code, price, viewState.value!.carts);
    });

    if (viewState.value!.voucherCodes.isEmpty)
      totalPrice.value =
          _useCase.calculatePrice(null, price, viewState.value!.carts);
  }

  _getCarts() async {
    var result = await _useCase.getCarts(viewState.value!);
    viewState.value = result[0];
    // numOfAllItems.value = result[1];
    totalPrice.value = result[1];
  }

  _useGetVoucher(UseVoucherCode event) async {
    var result = await _useCase.useVoucherCode(
        viewState.value!, event.code, totalPrice.value!);
    viewState.value = result[0];
    totalPrice.value = result[1];
  }

  @override
  void onClose() {
    viewState.close();
    _eventHandller.close();
    super.onClose();
  }
}
