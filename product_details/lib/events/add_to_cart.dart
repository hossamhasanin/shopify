import 'package:models/models.dart';

import './product_detail_event.dart';

class AddToCart extends ProductDetailsEvent {
  final Product product;
  const AddToCart({required this.product});

  @override
  List<Object?> get props => [product];
}
