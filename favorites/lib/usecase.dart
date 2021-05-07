import 'package:favorites/datasource.dart';
import 'package:favorites/viewstate.dart';
import 'package:models/models.dart';

class FavouritesUseCase {
  final FavoritesDataSource _dataSource;

  FavouritesUseCase({required FavoritesDataSource dataSource})
      : this._dataSource = dataSource;

  Future<FavouritesViewState> getFavorites(
      FavouritesViewState viewState, String lastId) async {
    try {
      var favorites = await _dataSource.getFavoriteProducts(lastId);

      return viewState.copy(
          favorites: favorites, loading: false, loadingMore: false, error: "");
    } catch (e) {
      return viewState.copy(
          favorites: [],
          loading: false,
          error: "Error in getting the favorites !");
    }
  }

  Future<bool> toggelFavorite(Product product) {
    try {
      _dataSource.toggelFavorite(product, product.isFavourite);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
