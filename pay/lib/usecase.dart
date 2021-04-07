import 'package:models/models.dart';
import 'package:pay/datasource.dart';
import 'package:pay/viewstate.dart';

class PayUseCase {
  final PayDatasource _datasource;
  PayUseCase({required PayDatasource payDatasource})
      : this._datasource = payDatasource;

  Future<PayViewState> getAddresses(PayViewState viewState) async {
    try {
      var addresses = await _datasource.getAddresses();
      return viewState.copy(
          loadingAddresses: false,
          errLoadingAddresses: "",
          addresses: addresses,
          curAddress: addresses.isNotEmpty ? addresses[0] : null);
    } catch (e) {
      return viewState.copy(
          loadingAddresses: false,
          errLoadingAddresses: "Error while loading",
          addresses: List.empty());
    }
  }

  Future<PayViewState> addAddress(
      PayViewState viewState, Address address) async {
    try {
      await _datasource.addAddress(address);
      var addresses = List.of(viewState.addresses);
      addresses.add(address);
      return viewState.copy(
          loadingAddresses: false,
          errLoadingAddresses: "",
          addresses: addresses,
          curAddress: addresses[0]);
    } catch (e) {
      return viewState.copy(
          loadingAddresses: false,
          errLoadingAddresses: "",
          addresses: List.empty());
    }
  }

  Future<PayViewState> updateAddress(
      PayViewState viewState, Address address) async {
    try {
      await _datasource.upadateAddress(address);
      var addresses = List.of(viewState.addresses);
      addresses[addresses.indexWhere((element) => element.id == address.id)] =
          address;
      return viewState.copy(
          loadingAddresses: false,
          errLoadingAddresses: "",
          addresses: addresses,
          curAddress: addresses[0]);
    } catch (e) {
      return viewState.copy(
          loadingAddresses: false,
          errLoadingAddresses: e.toString(),
          addresses: List.empty());
    }
  }

  Future<PayViewState> deleteAddress(
      PayViewState viewState, Address address) async {
    try {
      await _datasource.deleteAddress(address);
      var addresses = List.of(viewState.addresses);
      addresses.remove(address);
      return viewState.copy(
          loadingAddresses: false,
          errLoadingAddresses: "",
          addresses: addresses,
          curAddress: addresses.isNotEmpty ? addresses[0] : null);
    } catch (e) {
      return viewState.copy(
          loadingAddresses: false,
          errLoadingAddresses: "",
          addresses: List.empty());
    }
  }

  Future addOrder(PayViewState viewState, Order order) async {
    try {
      await _datasource.addOrder(order, viewState.voucherCodes);
      viewState.orderEventState.value = viewState.orderEventState.value!
          .copy(error: "", loading: false, sucessed: true);
    } catch (e) {
      viewState.orderEventState.value = viewState.orderEventState.value!.copy(
          error: "Error while adding the order",
          loading: false,
          sucessed: true);
    }
  }
}
