import 'package:models/models.dart';

abstract class CartDataSource {
  Future<List<Cart>> getCarts();
  Future removeProduct(String productId);

  Future<Code?> findVoucherCode(String code);
}
