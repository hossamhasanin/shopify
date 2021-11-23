import 'package:models/models.dart';

abstract class AllItemsRepo {
  Future<List<Product>> getPopItemes();
  Future<List<Category>> getCats();
}
