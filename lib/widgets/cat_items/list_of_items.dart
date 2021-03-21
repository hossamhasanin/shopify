import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:shopify/widgets/utils/components/product_card.dart';

class ListOfItems extends StatelessWidget {
  late Function(String) _loadmore;
  late Future Function() _refresh;
  late List<Product> _products;
  ScrollController _scrollController = ScrollController();
  ListOfItems(
      {required Function(String) loadmore,
      required List<Product> products,
      required Future Function() refresh})
      : this._loadmore = loadmore,
        this._products = products,
        this._refresh = refresh;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) =>
            _handelScrollEvent(notification, _products),
        child: GridView.builder(
          itemCount: _products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 10.0, crossAxisSpacing: 10.0),
          itemBuilder: (context, index) {
            var product = _products[index];
            return ProductCard(
              key: ValueKey(product),
              product: product,
            );
          },
          controller: _scrollController,
        ),
      ),
    );
  }

  bool _handelScrollEvent(
      ScrollNotification notification, List<Product> products) {
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      _loadmore(products.last.id);
    }
    return false;
  }
}
