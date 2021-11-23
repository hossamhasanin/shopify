import 'package:product_details/events/product_detail_event.dart';

class SelectColor extends ProductDetailsEvent {
  final int color;
  const SelectColor({required this.color});
  List<Object?> get props => [color];
}
