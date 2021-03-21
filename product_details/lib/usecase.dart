import 'package:models/models.dart';

import './repository.dart';
import './viewstate.dart';

class ProductDetailsUseCase {
  final ProductDetailsRepo _repo;

  const ProductDetailsUseCase({required ProductDetailsRepo repo})
      : this._repo = repo;

  Future<ProductDetailsViewState> addToCart(
      Product product, ProductDetailsViewState viewState) async {
    try {
      await _repo.addToCart(product);
      return viewState.copy(
          addingToCart: false, addToCartDone: true, errorInCart: "");
    } catch (e) {
      return viewState.copy(
          addingToCart: false,
          addToCartDone: false,
          errorInCart: "Error while adding this product to the cart");
    }
  }
}
