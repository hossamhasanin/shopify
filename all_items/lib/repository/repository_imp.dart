import 'package:models/models.dart';

import 'repository.dart';
import 'package:all_items/datasorce/datasource.dart';

class AllItemsRepoImp implements AllItemsRepo {
  AllItemsDataSource _networkDatasource;
  AllItemsDataSource _cashkDatasource;

  AllItemsRepoImp(
      {required AllItemsDataSource networkDatasource,
      required AllItemsDataSource cashDatasource})
      : this._networkDatasource = networkDatasource,
        this._cashkDatasource = cashDatasource;

  @override
  Stream<List<Category>> getCats() {
    try {
      return _networkDatasource.getCats().asStream().asyncMap((cats) async {
        await _cashkDatasource.cashCats(cats);
        return Future.value(cats);
      });
    } catch (e) {
      print(e);
      return _cashkDatasource.getCats().asStream();
    }
  }

  @override
  Stream<List<Product>> getItemes(
      String lastId, String catId, bool getPopular) {
    try {
      var stream = getPopular
          ? _networkDatasource.getPopularItems()
          : _networkDatasource.getItems(lastId, catId);
      return stream.asStream().asyncMap((items) async {
        getPopular
            ? await _cashkDatasource.cashPopularItems(items)
            : await _cashkDatasource.cashItems(items);
        return Future.value(items);
      });
    } catch (e) {
      print(e);
      var stream = getPopular
          ? _cashkDatasource.getPopularItems()
          : _cashkDatasource.getItems(lastId, catId);
      return stream.asStream();
    }
  }

  @override
  Stream<int>? noNotifications() {
    return _networkDatasource.noNotifications();
  }
}
