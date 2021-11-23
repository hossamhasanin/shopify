import 'package:cat_items/events/cat_items_event.dart';

class Refresh extends CatItemsEvent {
  final String catId;
  const Refresh({required this.catId});
  @override
  // TODO: implement props
  List<Object?> get props => [catId];
}
