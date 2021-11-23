import 'package:orders/events/orders_event.dart';

class GetCarts extends OrdersEvent {
  final String orderId;

  GetCarts({required this.orderId});
  @override
  List<Object?> get props => [orderId];
}
