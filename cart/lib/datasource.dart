import 'package:models/cart.dart';

abstract class CartDataSource {
  Future<List<Cart>> getCarts();
  Future removeProduct(String productId);
}
