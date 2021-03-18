import 'dart:async';

import 'package:all_items/all_items.dart';
import 'package:all_items/datasorce/datasource.dart';
import 'package:all_items/events/no_notifications_event.dart';
import 'package:all_items/repository/repository_imp.dart';
import 'package:all_items/usecase.dart';
import 'package:all_items/viewstate.dart';
import 'package:flutter/cupertino.dart';
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
          items: List.empty(),
          catsError: "",
          noNotifications: 0)
      .obs;
  late AllItemsUseCase _useCase;
  StreamController<AllItemsEvent> _eventHandler = StreamController();
  StreamSubscription? _getItemsListener;
  StreamSubscription? _getCatsListener;
  StreamSubscription? l;

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
      } else if (event is LoadMore) {
        _loadMore(event);
      } else if (event is NoNotificattions) {
        _getNoNotifications();
      }
    });
  }

  getItems() {
    _eventHandler.sink.add(GetItems(getPopular: false));
  }

  getPopularItems() {
    _eventHandler.sink.add(GetItems(getPopular: true));
  }

  getCats() {
    viewState.value = viewState.value.copy(loading: true, loadingCats: true);
    _eventHandler.sink.add(GetCats());
  }

  getNoNotifications() {
    _eventHandler.add(NoNotificattions());
  }

  loadMore(String lastId) {
    _eventHandler.sink.add(LoadMore(lastId: lastId));
  }

  _getItems(GetItems event) {
    _loadItemsUnit("", event.getPopular);
  }

  _getCats(GetCats event) {
    if (_getCatsListener != null) {
      _getCatsListener!.cancel();
      _getCatsListener = null;
    }
    _getCatsListener = _useCase.getCats(viewState.value).listen((state) {
      viewState.value = state;
      getPopularItems();
    })
      ..onDone(() {
        _getCatsListener!.cancel();
      });
  }

  _loadMore(LoadMore event) {
    viewState.value = viewState.value.copy(loadMore: true);

    _loadItemsUnit(event.lastId, false);
  }

  _loadItemsUnit(String lastId, bool getPopular) {
    if (_getItemsListener != null) {
      _getItemsListener!.cancel();
      _getItemsListener = null;
    }
    _getItemsListener =
        _useCase.getItems(lastId, getPopular, viewState.value).listen((state) {
      viewState.value = state;
    })
          ..onDone(() {
            _getItemsListener!.cancel();
          });
  }

  _getNoNotifications() {
    l = _useCase.getNoNotifications(viewState.value).listen((event) {
      viewState.value = event;
    })
      ..onError((e) {
        debugPrint(e);
      })
      ..onDone(() {
        l!.cancel();
      });
  }

  @override
  void onClose() {
    _eventHandler.close();
    viewState.close();
    if (_getItemsListener != null) {
      _getItemsListener!.cancel();
      _getItemsListener = null;
    }
    if (_getCatsListener != null) {
      _getCatsListener!.cancel();
      _getCatsListener = null;
    }
    super.onClose();
  }
}
