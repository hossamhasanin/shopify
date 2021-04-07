import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:models/models.dart';
import 'package:pay/eventstate.dart';

class PayViewState extends Equatable {
  final bool loadingAddresses;
  final String errLoadingAddresses;
  final List<Address> addresses;
  final List<String> govs;
  final List<String> cities;
  final Address curAddress;
  final String fullName;
  final String phone;
  final String paymentMethod;
  final Rx<EventState> orderEventState;
  final List<Cart> carts;
  final double totalPrice;
  final int numAllItems;
  final List<Code> voucherCodes;

  const PayViewState(
      {required this.addresses,
      required this.errLoadingAddresses,
      required this.loadingAddresses,
      required this.govs,
      required this.cities,
      required this.curAddress,
      required this.fullName,
      required this.phone,
      required this.paymentMethod,
      required this.orderEventState,
      required this.carts,
      required this.totalPrice,
      required this.numAllItems,
      required this.voucherCodes});

  @override
  List<Object?> get props => [
        addresses,
        curAddress,
        fullName,
        phone,
        errLoadingAddresses,
        loadingAddresses,
        paymentMethod,
        orderEventState,
        carts,
        govs,
        cities,
        numAllItems,
        totalPrice,
        voucherCodes
      ];

  PayViewState copy(
      {bool? loadingAddresses,
      String? errLoadingAddresses,
      List<Address>? addresses,
      List<String>? govs,
      List<String>? cities,
      Address? curAddress,
      String? fullName,
      String? phone,
      String? paymentMethod,
      Rx<EventState>? orderEventState,
      List<Cart>? carts,
      double? totalPrice,
      int? numAllItems,
      List<Code>? voucherCodes}) {
    if (cities != null)
      debugPrint("view state cities " + cities.length.toString());
    return PayViewState(
        loadingAddresses: loadingAddresses ?? this.loadingAddresses,
        errLoadingAddresses: errLoadingAddresses ?? this.errLoadingAddresses,
        addresses: addresses ?? this.addresses,
        govs: govs ?? this.govs,
        cities: cities ?? this.cities,
        curAddress: curAddress ?? this.curAddress,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        orderEventState: orderEventState ?? this.orderEventState,
        carts: carts ?? this.carts,
        totalPrice: totalPrice ?? this.totalPrice,
        numAllItems: numAllItems ?? this.numAllItems,
        voucherCodes: voucherCodes ?? this.voucherCodes);
  }
}
