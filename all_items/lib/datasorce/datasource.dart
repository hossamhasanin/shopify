import 'package:models/models.dart';

abstract class AllItemsDataSource {
  Future<List<Category>> getCats();
  Future<List<Product>> getPopularItems();
  Stream<int>? noNotifications();

  void initCashDatabase();
  Future<void>? cashCats(List<Category> cats);
  Future<void>? cashPopularItems(List<Product> items);
}
