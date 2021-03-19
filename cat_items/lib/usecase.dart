import 'package:cat_items/repository.dart';
import 'package:cat_items/viewstate.dart';

class CatItemsUseCase {
  final CatItemsRepo _repo;

  const CatItemsUseCase({required CatItemsRepo repo}) : this._repo = repo;

  Future<CatItemsViewState> getItems(
      String catId, String lastId, CatItemsViewState viewState) async {
    try {
      var items = await _repo.getCatItems(catId, lastId);
      viewState.items.addAll(items);
      return viewState.copy(loading: false, loadingMore: false);
    } catch (e) {
      return viewState.copy(error: "Failed to get the items");
    }
  }
}
