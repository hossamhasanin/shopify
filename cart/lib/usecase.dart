import 'package:cart/datasource.dart';
import 'package:cart/eventstate.dart';
import 'package:cart/viewstate.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class CartUseCase {
  final CartDataSource _dataSource;

  const CartUseCase({required CartDataSource dataSource})
      : this._dataSource = dataSource;

  Future<List> getCarts(CartViewState viewState) async {
    var carts = Cart.carts;
    var numItems = 0;
    double price = 0;
    carts.forEach((cart) {
      numItems += cart.numOfItem;
      price += cart.product.price * cart.numOfItem;
    });
    return [
      viewState.copy(carts: carts, loading: false, error: ""),
      numItems,
      price
    ];
  }

  Future<EventState> removeProduct(String id, EventState eventState) async {
    try {
      await _dataSource.removeProduct(id);

      return eventState.copy(removeDone: true, removeError: "");
    } catch (e) {
      return eventState.copy(
          removeDone: false, removeError: "Error happend while removing");
    }
  }
}
