import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:pay/datasource.dart';
import 'package:pay/eg_gov_cities_datasource.dart';
import 'package:pay/events/add_address.dart';
import 'package:pay/events/add_order.dart';
import 'package:pay/events/dalete_address.dart';
import 'package:pay/events/get_addresses.dart';
import 'package:pay/events/set_cities.dart';
import 'package:pay/events/set_govs.dart';
import 'package:pay/events/update_address.dart';
import 'package:pay/eventstate.dart';
import 'package:pay/usecase.dart';
import 'package:pay/viewstate.dart';
import './events/pay_event.dart';
import './events/move_process.dart';

class PayController extends GetxController {
  late Rx<PayViewState> viewstate;

  RxInt processIndex = 0.obs;
  final processes = ['Shipping details', 'Payment method', 'Order status'];
  StreamController<PayEvent> _eventHandler = StreamController();
  late PayUseCase _useCase;

  PayController(
      {required PayDatasource datasource,
      required List<Cart> carts,
      required double totalPrice,
      required int numAllItems,
      List<Code> voucherCodes = const <Code>[]}) {
    viewstate = PayViewState(
            addresses: [],
            loadingAddresses: false,
            errLoadingAddresses: "",
            govs: [],
            cities: [],
            curAddress: Address(
                id: "",
                governorate: "",
                city: "",
                street: "",
                optionalInfo: ""),
            fullName: "",
            phone: "",
            paymentMethod: PaymentEnum.PayOnDeleviry.toString(),
            carts: carts,
            totalPrice: totalPrice,
            numAllItems: numAllItems,
            orderEventState:
                EventState(error: "", loading: false, sucessed: false).obs,
            voucherCodes: voucherCodes)
        .obs;

    _useCase = PayUseCase(payDatasource: datasource);

    _eventHandler.stream.listen((event) {
      if (event is MoveProcess) {
        _move(event);
      } else if (event is GetAddresses) {
        _getAddresses();
      } else if (event is AddAddress) {
        _addAddress(event);
      } else if (event is UpdateAddress) {
        _updateAddress(event);
      } else if (event is DeleteAddress) {
        _deleteAddress(event);
      } else if (event is AddOrder) {
        _addOrder(event);
      }
    });
  }

  move(int index) {
    _eventHandler.sink.add(MoveProcess(processIndex: index));
  }

  getAddresses() {
    viewstate.value = viewstate.value!.copy(loadingAddresses: true);
    _eventHandler.sink.add(GetAddresses());
  }

  addAddress(Address address) {
    _eventHandler.sink.add(AddAddress(address: address));
  }

  updateAddress(Address address) {
    _eventHandler.sink.add(UpdateAddress(address: address));
  }

  deleteAddress(Address address) {
    _eventHandler.sink.add(DeleteAddress(address: address));
  }

  addOrder() {
    var order = Order(
        orderNum: "",
        officialName: viewstate.value!.fullName,
        phone: viewstate.value!.phone,
        payMethod: viewstate.value!.paymentMethod,
        carts: viewstate.value!.carts,
        address: viewstate.value!.curAddress.toString(),
        totalPrice: viewstate.value!.totalPrice,
        numAllItems: viewstate.value!.numAllItems);

    viewstate.value!.orderEventState.value =
        viewstate.value!.orderEventState.value!.copy(loading: true);
    _eventHandler.sink.add(AddOrder(order: order));
  }

  _move(MoveProcess event) {
    processIndex.value = event.processIndex;
    debugPrint("moved to " + processIndex.value.toString());
  }

  _getAddresses() async {
    viewstate.value = await _useCase.getAddresses(viewstate.value!);
  }

  _addAddress(AddAddress event) async {
    viewstate.value =
        await _useCase.addAddress(viewstate.value!, event.address);
  }

  _updateAddress(UpdateAddress event) async {
    viewstate.value =
        await _useCase.updateAddress(viewstate.value!, event.address);
  }

  _deleteAddress(DeleteAddress event) async {
    viewstate.value =
        await _useCase.deleteAddress(viewstate.value!, event.address);
  }

  _addOrder(AddOrder event) async {
    await _useCase.addOrder(viewstate.value!, event.order);
  }

  @override
  void onClose() {
    _eventHandler.close();
    processIndex.close();
    viewstate.close();
    super.onClose();
  }
}
