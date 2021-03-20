import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class AllItemsViewState extends Equatable {
  final bool loading;
  final bool loadingCats;
  final String error;
  final List<Product> popularItems;
  final List<Category> cats;
  final String? catId;
  final String catsError;
  final bool loadMore;

  const AllItemsViewState(
      {required this.error,
      required this.cats,
      required this.popularItems,
      required this.catsError,
      required this.catId,
      required this.loading,
      required this.loadMore,
      required this.loadingCats});

  @override
  // TODO: implement props
  List<Object> get props =>
      [loading, popularItems, loadingCats, error, loadMore];

  AllItemsViewState copy(
      {bool? loading,
      bool? loadingCats,
      List<Product>? popularItems,
      String? catId,
      String? catsError,
      List<Category>? cats,
      String? error,
      bool? loadMore}) {
    return AllItemsViewState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        popularItems: popularItems ?? this.popularItems,
        catId: catId ?? this.catId,
        cats: cats ?? this.cats,
        catsError: catsError ?? this.catsError,
        loadMore: loadMore ?? this.loadMore,
        loadingCats: loadingCats ?? this.loadingCats);
  }
}
