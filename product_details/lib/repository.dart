import 'package:models/models.dart';

abstract class ProductDetailsRepo {
  Future addToCart(Cart cart);
  Future removeFromCart(Cart cart);
  Future editProductCart(Cart cart);
}
