import 'package:all_items/events/all_items_event.dart';

class LoadMore extends AllItemsEvent {
  String lastId;
  LoadMore({required this.lastId});
  @override
  List<Object> get props => [lastId];
}
