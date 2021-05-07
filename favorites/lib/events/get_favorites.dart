import 'package:favorites/events/favorites_event.dart';

class GetFavorites extends FavoritesEvent {
  final String lastId;

  GetFavorites({required this.lastId});

  @override
  // TODO: implement props
  List<Object?> get props => [lastId];
}
