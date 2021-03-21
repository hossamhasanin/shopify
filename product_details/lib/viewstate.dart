import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class ProductDetailsViewState extends Equatable {
  final Product product;
  final bool addingToCart;
  final String errorInCart;
  final bool addToCartDone;

  const ProductDetailsViewState(
      {required this.product,
      required this.addToCartDone,
      required this.addingToCart,
      required this.errorInCart});

  @override
  List<Object?> get props =>
      [product, addingToCart, addToCartDone, errorInCart];

  ProductDetailsViewState copy(
      {Product? product,
      bool? addingToCart,
      String? errorInCart,
      bool? addToCartDone}) {
    return ProductDetailsViewState(
        product: product ?? this.product,
        addToCartDone: addToCartDone ?? this.addToCartDone,
        addingToCart: addingToCart ?? this.addingToCart,
        errorInCart: errorInCart ?? this.errorInCart);
  }
}
