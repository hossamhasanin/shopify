import 'package:models/models.dart';

abstract class FavoritesDataSource {
  Future<List<Product>> getFavoriteProducts(String lastId);

  Future toggelFavorite(Product product, bool state);
}
