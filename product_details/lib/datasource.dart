import 'package:models/models.dart';

abstract class ProductDetailsDataSource {
  Future addToCart(Product product);
}
