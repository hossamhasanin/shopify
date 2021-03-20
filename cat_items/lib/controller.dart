import 'dart:async';

import 'package:cat_items/datasource.dart';
import 'package:cat_items/events/cat_items_event.dart';
import 'package:cat_items/events/get_items.dart';
import 'package:cat_items/events/load_more.dart';
import 'package:cat_items/events/refresh.dart';
import 'package:cat_items/repository.dart';
import 'package:cat_items/repository_impl.dart';
import 'package:cat_items/usecase.dart';
import 'package:cat_items/viewstate.dart';
import 'package:get/get.dart';

class CatItemsController extends GetxController {
  Rx<CatItemsViewState> viewstate = CatItemsViewState(
          loading: false, loadingMore: false, items: List.empty(), error: "")
      .obs;

  StreamController<CatItemsEvent> _eventHandler = StreamController();

  late CatItemsUseCase _useCase;
  CatItemsController(
      {required CatItemsDatasource cashDatasource,
      required CatItemsDatasource networkDatasource}) {
    _useCase = CatItemsUseCase(
        repo: RepositoryImpl(
            cashDataSource: cashDatasource,
            networkDatasource: networkDatasource));

    _eventHandler.stream.listen((event) {
      if (event is GetItems) {
        _getItems(event);
      } else if (event is LoadMore) {
        _loadMore(event);
      } else if (event is Refresh) {
        _refresh(event);
      }
    });
  }

  getItems(String catId) {
    _eventHandler.sink.add(GetItems(catId: catId));
  }

  loadMore(String catId, String lastId) {
    _eventHandler.sink.add(LoadMore(catId: catId, lastId: lastId));
  }

  refreshItems(String catId) {
    _eventHandler.sink.add(Refresh(catId: catId));
  }

  _getItems(GetItems event) async {
    viewstate.value = await _useCase.getItems(event.catId, "", viewstate.value);
  }

  _loadMore(LoadMore event) async {
    viewstate.value =
        await _useCase.getItems(event.catId, event.lastId, viewstate.value);
  }

  _refresh(Refresh event) async {
    viewstate.value = await _useCase.getItems(event.catId, "", viewstate.value);
  }

  @override
  void onClose() {
    _eventHandler.close();
    viewstate.close();
    super.onClose();
  }
}
