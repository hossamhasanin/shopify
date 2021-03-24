import 'dart:async';

import 'package:app_bar/events/num_cart_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';

import 'datasource.dart';
import 'package:app_bar/events/app_bar_event.dart';
import 'package:app_bar/events/notification_cont.dart';

class AppBarController extends GetxController {
  RxInt noNotifications = 0.obs;
  // RxInt numCartProduct = 0.obs;
  RxList<Cart> carts = List<Cart>.empty().obs;
  late AppBarDatasource _datasource;
  late StreamController<AppBarEvent> _eventHandler = StreamController();
  StreamSubscription? _noNotificationsListener;

  AppBarController({required AppBarDatasource datasource}) {
    this._datasource = datasource;
    _eventHandler.stream.listen((event) {
      if (event is GetNotificationCount) {
        _getNoNotifications();
      } else if (event is NumCartProduct) {
        _getNumCartProduct();
      }
    });
  }

  getNoNotifications() {
    _eventHandler.sink.add(GetNotificationCount());
  }

  getNumCartProduct() {
    _eventHandler.sink.add(NumCartProduct());
  }

  _getNumCartProduct() async {
    await _datasource.numCartProducts();
  }

  _getNoNotifications() {
    _noNotificationsListener = _datasource.noNotifications().listen((number) {
      debugPrint("num is " + number.toString());
      noNotifications.value = number;
      debugPrint("noti is " + noNotifications.value.toString());
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
  void dispose() {
    _eventHandler.close();
    if (_noNotificationsListener != null) {
      _noNotificationsListener!.cancel();
    }
    noNotifications.close();
    super.dispose();
  }
}
