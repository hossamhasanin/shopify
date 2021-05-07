import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class OrdersViewState extends Equatable {
  final List<Order> orders;
  final bool loading;
  final String error;

  OrdersViewState(
      {required this.orders, required this.loading, required this.error});

  @override
  List<Object?> get props => [orders, loading, error];

  OrdersViewState copy({List<Order>? orders, bool? loading, String? error}) {
    return OrdersViewState(
        orders: orders ?? this.orders,
        loading: loading ?? this.loading,
        error: error ?? this.error);
  }
}
