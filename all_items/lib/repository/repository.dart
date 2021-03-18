import 'package:models/models.dart';

abstract class AllItemsRepo {
  Stream<List<Product>> getItemes(String lastId, String catId, bool getPopular);
  Stream<List<Category>> getCats();
  Stream<int>? noNotifications();
}
