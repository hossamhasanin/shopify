import 'package:all_items/all_items.dart';
import 'package:cat_items/datasource.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:models/models.dart';

class CashDatabase implements AllItemsDataSource, CatItemsDatasource {
  Box<Category>? catsBox;
  Box<Product>? productsBox;
  Box<Product>? popularProductsBox;

  @override
  Future<void> cashCats(List<Category> cats) {
    Map<dynamic, Category> map = {};
    cats.forEach((cat) {
      map[cat.id] = cat;
    });
    return catsBox!.putAll(map);
  }

  @override
  Future<void> cashItems(List<Product> items) {
    Map<dynamic, Product> map = {};
    items.forEach((item) {
      map[item.id] = item;
    });
    return productsBox!.putAll(map);
  }

  @override
  Future<List<Category>> getCats() {
    return Future.value(catsBox!.values.toList());
  }

  @override
  Future<List<Product>> getPopularItems() {
    return Future.value(popularProductsBox!.values.toList());
  }

  @override
  Future<void> cashPopularItems(List<Product> items) {
    Map<dynamic, Product> map = {};
    items.forEach((item) {
      map[item.id] = item;
    });
    return popularProductsBox!.putAll(map);
  }

  @override
  void initCashDatabase() async {
    if (!Hive.isAdapterRegistered(0)) {
      await Hive.initFlutter();
      Hive.registerAdapter(CategoryAdapter());
      catsBox = await Hive.openBox<Category>("catsBox");
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProductAdapter());
      popularProductsBox = await Hive.openBox("productsBox");
      productsBox = await Hive.openBox("productsBox");
    }
  }

  @override
  Stream<int>? noNotifications() {
    return null;
  }

  @override
  Future<List<Product>> getItems(String catId, String lastId) {
    return Future.value(productsBox!.values.toList());
  }
}
