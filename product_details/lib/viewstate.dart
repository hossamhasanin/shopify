import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class ProductDetailsViewState extends Equatable {
  final Product product;
  final bool addingToCart;
  final String errorInCart;
  final bool addToCartDone;
  final int numOfItem;
  final int selectedColor;
  final bool removingFromCart;
  final bool removeFromCartDone;
  final bool editCartDone;
  final bool isNew;
  const ProductDetailsViewState(
      {required this.product,
      required this.addToCartDone,
      required this.addingToCart,
      required this.errorInCart,
      required this.numOfItem,
      required this.removingFromCart,
      required this.removeFromCartDone,
      required this.editCartDone,
      required this.selectedColor,
      required this.isNew});

  @override
  List<Object?> get props => [
        product,
        addingToCart,
        addToCartDone,
        removingFromCart,
        removeFromCartDone,
        numOfItem,
        errorInCart,
        editCartDone,
        selectedColor,
        isNew
      ];

  ProductDetailsViewState copy(
      {Product? product,
      bool? addingToCart,
      String? errorInCart,
      bool? addToCartDone,
      int? numOfItem,
      bool? removingFromCart,
      bool? removeFromCartDone,
      bool? editCartDone,
      int? selectedColor,
      bool? isNew}) {
    return ProductDetailsViewState(
        product: product ?? this.product,
        addToCartDone: addToCartDone ?? this.addToCartDone,
        addingToCart: addingToCart ?? this.addingToCart,
        errorInCart: errorInCart ?? this.errorInCart,
        numOfItem: numOfItem ?? this.numOfItem,
        removingFromCart: removingFromCart ?? this.removingFromCart,
        removeFromCartDone: removeFromCartDone ?? this.removeFromCartDone,
        editCartDone: editCartDone ?? this.editCartDone,
        selectedColor: selectedColor ?? this.selectedColor,
        isNew: isNew ?? this.isNew);
  }
}
