import 'package:equatable/equatable.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import './product.dart';

class Cart extends Equatable {
  final Product product;
  final int numOfItem;
  final int selectedColor;

  Cart(
      {required this.product,
      required this.numOfItem,
      required this.selectedColor});

  @override
  List<Object?> get props => [product, numOfItem, selectedColor];

  static RxList<Cart> carts = <Cart>[].obs;
}
