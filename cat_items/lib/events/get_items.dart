import 'package:cat_items/events/cat_items_event.dart';

class GetItems extends CatItemsEvent {
  final String catId;

  const GetItems({required this.catId});
  @override
  List<Object?> get props => [catId];
}
