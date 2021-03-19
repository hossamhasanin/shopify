import 'package:models/models.dart';

abstract class CatItemsDatasource {
  Future<List<Product>> getItemsFromNetwork(String catId, String lastId);
  Future<List<Product>> getItemsFromCash(String catId);

  Future cashCatItems(String catId, List<Product> items);
}
