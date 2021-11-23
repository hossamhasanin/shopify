import 'package:models/models.dart';

abstract class ProductDetailsDataSource {
  Future addToCart(Cart cart);
  Future removeFromCart(Cart cart);
  Future editProductCart(Cart cart);
}
