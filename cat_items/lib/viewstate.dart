import 'package:cat_items/datasource.dart';
import 'package:cat_items/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class CatItemsViewState extends Equatable {
  final bool loading;
  final bool loadingMore;
  final List<Product> items;
  final String error;

  const CatItemsViewState(
      {required this.loading,
      required this.loadingMore,
      required this.items,
      required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [loading, loadingMore, items, error];

  CatItemsViewState copy(
      {bool? loading, bool? loadingMore, List<Product>? items, String? error}) {
    return CatItemsViewState(
        loading: loading ?? this.loading,
        loadingMore: loadingMore ?? this.loadingMore,
        items: items ?? this.items,
        error: error ?? this.error);
  }
}
