import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:pay/events/pay_event.dart';

import 'eg_gov_cities_datasource.dart';
import 'events/set_cities.dart';
import 'events/set_govs.dart';

class PutAddressController extends GetxController {
  late Rx<Address> address;
  RxList<String> govs = <String>[].obs;
  RxList<String> cities = <String>[].obs;

  StreamController<PayEvent> _eventHandler = StreamController();
  late GovCitiesDatasource _govCitiesDatasource;
  PutAddressController(
      {Address setAddress =
          const Address(id: "", street: "", governorate: "", city: "")}) {
    address = setAddress.obs;
    _govCitiesDatasource = GovCitiesDatasource();

    _eventHandler.stream.distinct().listen((event) {
      if (event is SetGovs) {
        _setGovs();
      } else if (event is SetCities) {
        _setCities(event);
      }
    });
  }

  setGovs() {
    _eventHandler.sink.add(SetGovs());
  }

  setCities(String gov) {
    _eventHandler.sink.add(SetCities(gov: gov));
  }

  _setGovs() async {
    await _govCitiesDatasource.init();
    var _govs = await _govCitiesDatasource.getAllGovs();
    govs.clear();
    govs.addAll(_govs);
  }

  _setCities(SetCities event) async {
    await _govCitiesDatasource.init();
    var govId = await _govCitiesDatasource.getGovId(event.gov);
    var _cities = await _govCitiesDatasource.getAllCities(govId);
    debugPrint("cities " + _cities.length.toString());
    cities.clear();
    cities.addAll(_cities);
    debugPrint("cities " + cities.length.toString());
  }
}
