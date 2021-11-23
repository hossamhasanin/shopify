import 'package:models/models.dart';

import './repository.dart';
import './datasource.dart';

class ProductDetailsRepoImpl implements ProductDetailsRepo {
  final ProductDetailsDataSource _networkDataSource;

  const ProductDetailsRepoImpl(
      {required ProductDetailsDataSource networkDataSource})
      : this._networkDataSource = networkDataSource;

  @override
  Future addToCart(Cart cart) {
    return _networkDataSource.addToCart(cart);
  }

  @override
  Future removeFromCart(Cart cart) {
    return _networkDataSource.removeFromCart(cart);
  }

  @override
  Future editProductCart(Cart cart) {
    return _networkDataSource.editProductCart(cart);
  }
}
