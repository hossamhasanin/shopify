import 'package:all_items/repository/repository.dart';
import 'package:all_items/viewstate.dart';
import 'package:flutter/material.dart';

class AllItemsUseCase {
  AllItemsRepo _repo;
  AllItemsUseCase({required AllItemsRepo repo}) : this._repo = repo;

  Future<AllItemsViewState> getItems(AllItemsViewState viewState) async {
    try {
      var items = await _repo.getPopItemes(viewState.catId!);
      debugPrint("pop items " + items.length.toString());
      return viewState.copy(loading: false, popularItems: items);
    } catch (e) {
      print(e);
      return Future.value(viewState.copy(
          error: "Error while loading the data",
          loadMore: false,
          loading: false));
    }
  }

  Future<AllItemsViewState> getCats(AllItemsViewState viewState) async {
    try {
      var cats = await _repo.getCats();
      return viewState.copy(
          loadingCats: false, cats: cats, catId: cats.first.id);
    } catch (e) {
      print(e);
      return Future.value(viewState.copy(
          loadingCats: false, catsError: "Error happend in loading cats"));
    }
  }
}
