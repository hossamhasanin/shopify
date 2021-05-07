import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class FavouritesViewState extends Equatable {
  final List<Product> favorites;
  final bool loading;
  final bool loadingMore;
  final String error;
  const FavouritesViewState(
      {required this.favorites,
      required this.loading,
      required this.loadingMore,
      required this.error});

  @override
  List<Object?> get props => [favorites, loading, loadingMore, error];

  FavouritesViewState copy(
      {List<Product>? favorites,
      bool? loading,
      bool? loadingMore,
      String? error}) {
    return FavouritesViewState(
        favorites: favorites ?? this.favorites,
        loading: loading ?? this.loading,
        error: error ?? this.error,
        loadingMore: loadingMore ?? this.loadingMore);
  }
}
