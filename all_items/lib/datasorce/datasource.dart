import 'package:models/models.dart';

abstract class AllItemsDataSource {
  Future<List<Category>> getCats();
  Future<List<Product>> getPopularItems();

  void initCashDatabase();
  Future<void>? cashCats(List<Category> cats);
  Future<void>? cashPopularItems(List<Product> items);
}
