import 'package:cat_items/events/cat_items_event.dart';

class LoadMore extends CatItemsEvent {
  final String lastId;
  final String catId;

  const LoadMore({required this.lastId, required this.catId});
  @override
  // TODO: implement props
  List<Object?> get props => [lastId, catId];
}
