import 'package:equatable/equatable.dart';
import 'package:models/cart.dart';

class CartViewState extends Equatable {
  final List<Cart> carts;
  final bool loading;
  final String error;

  const CartViewState(
      {required this.carts, required this.loading, required this.error});

  @override
  List<Object?> get props => [carts, loading, error];

  CartViewState copy(
      {List<Cart>? carts,
      bool? removed,
      String? removeError,
      bool? loading,
      String? error}) {
    return CartViewState(
        carts: carts ?? this.carts,
        loading: loading ?? this.loading,
        error: error ?? this.error);
  }
}
