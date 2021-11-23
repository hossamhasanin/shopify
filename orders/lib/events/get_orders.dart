import 'package:orders/events/orders_event.dart';

class GetOrders extends OrdersEvent {
  final String lastOrder;

  GetOrders({required this.lastOrder});

  @override
  List<Object?> get props => [lastOrder];
}
