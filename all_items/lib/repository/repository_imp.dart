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
  Future<List<Category>> getCats() async {
    try {
      var cats = await _networkDatasource.getCats();
      await _cashkDatasource.cashCats(cats);
      return cats;
    } catch (e) {
      print(e);
      return _cashkDatasource.getCats();
    }
  }

  @override
  Future<List<Product>> getPopItemes(String catId) async {
    var popItems;
    try {
      popItems = await _networkDatasource.getPopularItems();
      await _cashkDatasource.cashPopularItems(popItems);
    } catch (e) {
      print(e);
      popItems = _cashkDatasource.getPopularItems();
    }
    return popItems;
  }
}
