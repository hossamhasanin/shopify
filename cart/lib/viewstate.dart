import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class CartViewState extends Equatable {
  final List<Cart> carts;
  final bool loading;
  final String error;
  final List<Code> voucherCodes;
  final bool loadingCode;
  final String errorCode;

  const CartViewState(
      {required this.carts,
      required this.loading,
      required this.error,
      required this.errorCode,
      required this.voucherCodes,
      required this.loadingCode});

  @override
  List<Object?> get props =>
      [carts, loading, error, voucherCodes, errorCode, loadingCode];

  CartViewState copy(
      {List<Cart>? carts,
      bool? removed,
      String? removeError,
      bool? loading,
      String? error,
      List<Code>? voucherCodes,
      bool? loadingCode,
      String? errorCode}) {
    return CartViewState(
        carts: carts ?? this.carts,
        loading: loading ?? this.loading,
        error: error ?? this.error,
        voucherCodes: voucherCodes ?? this.voucherCodes,
        loadingCode: loadingCode ?? this.loadingCode,
        errorCode: errorCode ?? this.errorCode);
  }
}
