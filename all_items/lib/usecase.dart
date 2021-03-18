import 'package:all_items/repository/repository.dart';
import 'package:all_items/viewstate.dart';
import 'package:flutter/material.dart';

class AllItemsUseCase {
  AllItemsRepo _repo;
  AllItemsUseCase({required AllItemsRepo repo}) : this._repo = repo;

  Stream<AllItemsViewState> getItems(
      String lastId, bool getPopular, AllItemsViewState viewState) {
    try {
      return _repo
          .getItemes(lastId, viewState.catId!, getPopular)
          .asyncMap((items) {
        return getPopular
            ? viewState.copy(loading: false, popularItems: items)
            : viewState.copy(loading: false, loadMore: false, items: items);
      });
    } catch (e) {
      print(e);
      return Stream.value(viewState.copy(
          error: "Error while loading the data",
          loadMore: false,
          loading: false));
    }
  }

  Stream<AllItemsViewState> getCats(AllItemsViewState viewState) {
    try {
      return _repo.getCats().asyncMap((cats) {
        return viewState.copy(
            loadingCats: false, cats: cats, catId: cats.first.id);
      });
    } catch (e) {
      print(e);
      return Stream.value(viewState.copy(
          loadingCats: false, catsError: "Error happend in loading cats"));
    }
  }

  Stream<AllItemsViewState> getNoNotifications(AllItemsViewState viewState) {
    return _repo.noNotifications()!.asyncMap((event) {
      debugPrint("noti count" + event.toString());
      return viewState.copy(noNotifications: event);
    });
  }
}
