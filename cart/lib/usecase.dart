import 'package:cart/datasource.dart';
import 'package:cart/errors/cant_use_voucher_error.dart';
import 'package:cart/eventstate.dart';
import 'package:cart/viewstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class CartUseCase {
  final CartDataSource _dataSource;

  const CartUseCase({required CartDataSource dataSource})
      : this._dataSource = dataSource;

  Future<List> getCarts(CartViewState viewState) async {
    var carts = Cart.carts;
    double price = 0;
    price = calculatePrice(null, price, carts);
    debugPrint("usecase price " + price.toString());
    debugPrint("usecase carts " + carts.length.toString());
    return [viewState.copy(carts: carts, loading: false, error: ""), price];
  }

  Future<EventState> removeProduct(String id, EventState eventState) async {
    try {
      await _dataSource.removeProduct(id);

      return eventState.copy(done: true, error: "");
    } catch (e) {
      return eventState.copy(
          done: false, error: "Error happend while removing");
    }
  }

  Future<List> useVoucherCode(
      CartViewState viewState, String voucherCode, double totalPrice) async {
    double price = totalPrice;

    try {
      Code? code = await _dataSource.findVoucherCode(voucherCode);
      price = calculatePrice(code, totalPrice, viewState.carts);
      var codes = viewState.voucherCodes;
      if (code != null)
        codes.add(code);
      else
        throw CantUseVoucherCodeException(
            message: "This code is not valid or does not exist");

      if (codes.contains(code))
        throw CantUseVoucherCodeException(
            message: "You can't use the same code twice pro");

      return [
        viewState.copy(loadingCode: false, errorCode: "", voucherCodes: codes),
        price
      ];
    } on CantUseVoucherCodeException catch (e) {
      return [
        viewState.copy(loadingCode: false, errorCode: e.toString()),
        price
      ];
    } catch (e) {
      debugPrint("has error " + e.toString());
      return [
        viewState.copy(loadingCode: false, errorCode: "Error in code"),
        price
      ];
    }
  }

  double calculatePrice(Code? code, double totalPrice, List<Cart> carts) {
    double price = 0.0;

    if (code != null) {
      if (code.cats.isNotEmpty) {
        price = 0.0;
        carts.forEach((cart) {
          if (code.cats.contains(cart.product.catId)) {
            var oldPrice = cart.product.price * cart.numOfItem;

            price += oldPrice;
          }
        });
        if (code.discountAmount != 0.0) {
          price = totalPrice - code.discountAmount;
        } else if (code.discountPercent != 0.0) {
          price = totalPrice - (price * code.discountPercent);
        }
      } else if (code.products.isNotEmpty) {
        carts.forEach((cart) {
          if (code.products.contains(cart.product.id)) {
            var oldPrice = cart.product.price * cart.numOfItem;

            if (code.discountAmount != 0.0) {
              price += oldPrice - code.discountAmount;
            } else if (code.discountPercent != 0.0) {
              price += oldPrice - (oldPrice * code.discountPercent);
            }
          }
        });
      } else {
        if (code.discountAmount != 0.0) {
          price = totalPrice - code.discountAmount;
        } else if (code.discountPercent != 0.0) {
          price = totalPrice - (totalPrice * code.discountPercent);
        }
      }
    } else {
      for (Cart cart in Cart.carts) {
        price += cart.product.price * cart.numOfItem;
      }

      if (carts.isEmpty) {
        price = 0.0;
      }
    }

    return price;
  }
}
