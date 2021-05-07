import 'package:orders/events/orders_event.dart';

class CancelOrder extends OrdersEvent {
  final String orderId;

  CancelOrder({required this.orderId});
  @override
  List<Object?> get props => [orderId];
}
