import 'package:models/models.dart';

abstract class CatItemsRepo {
  Future<List<Product>> getCatItems(String catId, String lastId);
}
