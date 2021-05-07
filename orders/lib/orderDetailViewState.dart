import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class OrderDetailViewState extends Equatable {
  final Order? order;
  final List<Cart> carts;
  final bool loadingCarts;
  final String errorCarts;

  OrderDetailViewState(
      {required this.carts,
      required this.order,
      required this.loadingCarts,
      required this.errorCarts});

  @override
  List<Object?> get props => [order, loadingCarts, errorCarts, carts];

  OrderDetailViewState copy(
      {Order? order,
      List<Cart>? carts,
      bool? loadingCarts,
      String? errorCarts}) {
    return OrderDetailViewState(
        order: order ?? this.order,
        loadingCarts: loadingCarts ?? this.loadingCarts,
        errorCarts: errorCarts ?? this.errorCarts,
        carts: carts ?? this.carts);
  }
}
