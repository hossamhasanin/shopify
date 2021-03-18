import 'package:all_items/events/all_items_event.dart';

class GetItems extends AllItemsEvent {
  final bool getPopular;
  GetItems({required this.getPopular});
  @override
  // TODO: implement props
  List<Object> get props => [getPopular];
}
