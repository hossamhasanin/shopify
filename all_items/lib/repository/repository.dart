import 'package:models/models.dart';

abstract class AllItemsRepo {
  Future<List<Product>> getPopItemes(String catId);
  Future<List<Category>> getCats();
  Stream<int>? noNotifications();
}
