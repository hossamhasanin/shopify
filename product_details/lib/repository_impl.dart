import 'package:models/models.dart';

import './repository.dart';
import './datasource.dart';

class ProductDetailsRepoImpl implements ProductDetailsRepo {
  final ProductDetailsDataSource _networkDataSource;

  const ProductDetailsRepoImpl(
      {required ProductDetailsDataSource networkDataSource})
      : this._networkDataSource = networkDataSource;

  @override
  Future addToCart(Product product) {
    return _networkDataSource.addToCart(product);
  }
}
