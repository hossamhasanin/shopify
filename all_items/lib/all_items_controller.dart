import 'dart:async';

import 'package:all_items/all_items.dart';
import 'package:all_items/datasorce/datasource.dart';
import 'package:all_items/repository/repository_imp.dart';
import 'package:all_items/usecase.dart';
import 'package:all_items/viewstate.dart';
import 'package:get/get.dart';
import 'events/all_items_event.dart';

class AllItemsController extends GetxController {
  Rx<AllItemsViewState> viewState = AllItemsViewState(
          loading: false,
          loadMore: false,
          error: "",
          catId: null,
          cats: List.empty(),
          popularItems: List.empty(),
          loadingCats: false,
          catsError: "")
      .obs;
  late AllItemsUseCase _useCase;
  StreamController<AllItemsEvent> _eventHandler = StreamController();

  AllItemsController(
      {required AllItemsDataSource networkDatasource,
      required AllItemsDataSource cashDatasource}) {
    _useCase = AllItemsUseCase(
        repo: AllItemsRepoImp(
            networkDatasource: networkDatasource,
            cashDatasource: cashDatasource));

    _eventHandler.stream.listen((event) {
      if (event is GetItems) {
        _getItems(event);
      } else if (event is GetCats) {
        _getCats(event);
      }
    });
  }

  getPopularItems() {
    _eventHandler.sink.add(GetItems());
  }

  getCats() {
    viewState.value = viewState.value?.copy(loading: true, loadingCats: true);
    _eventHandler.sink.add(GetCats());
  }

  _getItems(GetItems event) async {
    viewState.value = await _useCase.getItems(viewState.value!);
  }

  _getCats(GetCats event) async {
    viewState.value = await _useCase.getCats(viewState.value!);
    getPopularItems();
  }

  @override
  void onClose() {
    _eventHandler.close();
    viewState.close();
    super.onClose();
  }
}
