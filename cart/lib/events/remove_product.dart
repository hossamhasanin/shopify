import 'package:cart/events/cart_event.dart';

class RemoveProduct extends CartEvent {
  final String id;
  const RemoveProduct({required this.id});
  @override
  List<Object?> get props => [id];
}
