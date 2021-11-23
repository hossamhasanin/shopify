import 'package:models/models.dart';

abstract class CatItemsDatasource {
  Future<List<Product>> getItems(String catId, String lastId);

  Future cashItems(List<Product> items);
}
