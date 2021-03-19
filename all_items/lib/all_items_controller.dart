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
          catsError: "",
          noNotifications: 0)
      .obs;
  late AllItemsUseCase _useCase;
  StreamController<AllItemsEvent> _eventHandler = StreamController();

  StreamSubscription? _noNotificationsListener;

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
      } else if (event is NoNotificattions) {
        _getNoNotifications();
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

  getNoNotifications() {
    _eventHandler.add(NoNotificattions());
  }

  _getItems(GetItems event) async {
    viewState.value = await _useCase.getItems(viewState.value!);
  }

  _getCats(GetCats event) async {
    viewState.value = await _useCase.getCats(viewState.value!);
    getPopularItems();
  }

  _getNoNotifications() {
    _noNotificationsListener =
        _useCase.getNoNotifications(viewState.value!).listen((state) {
      debugPrint("state is " + state.noNotifications.toString());
      viewState.value = state;
      debugPrint("set state is " + viewState.value!.noNotifications.toString());
    })
          ..onError((e) {
            debugPrint(e);
          })
          ..onDone(() {
            _noNotificationsListener!.cancel();
            debugPrint("done noti");
          });
  }

  @override
  void onClose() {
    _eventHandler.close();
    viewState.close();
    if (_noNotificationsListener != null) {
      _noNotificationsListener!.cancel();
      _noNotificationsListener = null;
    }
    super.onClose();
  }
}
