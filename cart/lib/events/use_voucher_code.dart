import 'package:cart/events/cart_event.dart';

class UseVoucherCode extends CartEvent {
  final String code;

  UseVoucherCode({required this.code});

  @override
  List<Object?> get props => [code];
}
