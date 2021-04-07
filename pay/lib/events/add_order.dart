import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:pay/events/pay_event.dart';

class AddOrder extends PayEvent {
  final Order order;

  const AddOrder({required this.order});

  @override
  List<Object?> get props => [order];
}
