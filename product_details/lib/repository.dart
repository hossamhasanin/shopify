import 'package:models/models.dart';

abstract class ProductDetailsRepo {
  Future addToCart(Product product);
}
