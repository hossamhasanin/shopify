import 'package:cat_items/datasource.dart';
import 'package:cat_items/repository.dart';
import 'package:models/product.dart';

class RepositoryImpl implements CatItemsRepo {
  final CatItemsDatasource _networkDatasource;
  final CatItemsDatasource _cashDataSource;

  const RepositoryImpl(
      {required CatItemsDatasource networkDatasource,
      required CatItemsDatasource cashDataSource})
      : this._networkDatasource = networkDatasource,
        this._cashDataSource = cashDataSource;

  @override
  Future<List<Product>> getCatItems(String catId, String lastId) async {
    try {
      var items = await _networkDatasource.getItemsFromNetwork(catId, lastId);
      await _cashDataSource.cashCatItems(catId, items);
      return items;
    } catch (e) {
      return _cashDataSource.getItemsFromCash(catId);
    }
  }
}
