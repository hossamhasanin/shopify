import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'datasource.dart';
import 'package:app_bar/events/app_bar_event.dart';
import 'package:app_bar/events/notification_cont.dart';

class AppBarController extends GetxController {
  RxInt noNotifications = 0.obs;
  late AppBarDatasource _datasource;
  late StreamController<AppBarEvent> _eventHandler = StreamController();
  StreamSubscription? _noNotificationsListener;

  AppBarController({required AppBarDatasource datasource}) {
    this._datasource = datasource;
    _eventHandler.stream.listen((event) {
      if (event is GetNotificationCount) {
        _getNoNotifications();
      }
    });
  }

  getNoNotifications() {
    _eventHandler.sink.add(GetNotificationCount());
  }

  _getNoNotifications() {
    _noNotificationsListener = _datasource.noNotifications()!.listen((number) {
      noNotifications.value = number;
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
