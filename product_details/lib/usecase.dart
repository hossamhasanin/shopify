import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';

import './repository.dart';
import './viewstate.dart';

class ProductDetailsUseCase {
  final ProductDetailsRepo _repo;

  const ProductDetailsUseCase({required ProductDetailsRepo repo})
      : this._repo = repo;

  Future<ProductDetailsViewState> addToCart(
      Cart cart, ProductDetailsViewState viewState) async {
    try {
      await _repo.addToCart(cart);
      return viewState.copy(
          editCartDone: false,
          addingToCart: false,
          addToCartDone: true,
          removingFromCart: false,
          removeFromCartDone: false,
          errorInCart: "");
    } catch (e) {
      debugPrint("koko" + e.toString());
      return viewState.copy(
          editCartDone: false,
          removeFromCartDone: false,
          removingFromCart: false,
          addingToCart: false,
          addToCartDone: false,
          errorInCart: "Error while adding this product to the cart");
    }
  }

  Future<ProductDetailsViewState> removeFromCart(
      Cart cart, ProductDetailsViewState viewState) async {
    try {
      await _repo.removeFromCart(cart);
      return viewState.copy(
          addToCartDone: false,
          addingToCart: false,
          removingFromCart: false,
          removeFromCartDone: true,
          errorInCart: "");
    } catch (e) {
      debugPrint("koko" + e.toString());
      return viewState.copy(
          removingFromCart: false,
          removeFromCartDone: false,
          errorInCart: "Error while adding this product to the cart");
    }
  }

  Future<ProductDetailsViewState> editProductCart(
      Cart cart, ProductDetailsViewState viewState) async {
    try {
      await _repo.editProductCart(cart);
      return viewState.copy(
          addingToCart: false,
          addToCartDone: false,
          removingFromCart: false,
          removeFromCartDone: false,
          errorInCart: "",
          editCartDone: true);
    } catch (e) {
      debugPrint("koko " + e.toString());
      return viewState.copy(
          addToCartDone: false,
          addingToCart: false,
          editCartDone: false,
          removingFromCart: false,
          removeFromCartDone: false,
          errorInCart: "Error while editing this product to the cart");
    }
  }
}
