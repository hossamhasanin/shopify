import 'dart:async';

import 'package:favorites/datasource.dart';
import 'package:favorites/events/favorites_event.dart';
import 'package:favorites/events/get_favorites.dart';
import 'package:favorites/usecase.dart';
import 'package:favorites/viewstate.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

class FavoritesController extends GetxController {
  final Rx<FavouritesViewState> viewState = FavouritesViewState(
          favorites: [], loading: false, loadingMore: false, error: "")
      .obs;

  late FavouritesUseCase _useCase;
  StreamController<FavoritesEvent> _eventHandller = StreamController();

  FavoritesController({required FavoritesDataSource dataSource}) {
    _useCase = FavouritesUseCase(dataSource: dataSource);

    _eventHandller.stream.listen((event) {
      if (event is GetFavorites) {
        _getFavorites(event);
      }
    });
  }

  getFavorites(String lastId) {
    viewState.value = viewState.value!
        .copy(loading: lastId.isEmpty, loadingMore: lastId.isNotEmpty);
    _eventHandller.sink.add(GetFavorites(lastId: lastId));
  }

  _getFavorites(GetFavorites event) async {
    viewState.value =
        await _useCase.getFavorites(viewState.value!, event.lastId);
  }

  Future<bool> toggelFavorite(Product product) {
    return _useCase.toggelFavorite(product);
  }

  @override
  void onClose() {
    _eventHandller.close();
    viewState.close();
    super.onClose();
  }
}
