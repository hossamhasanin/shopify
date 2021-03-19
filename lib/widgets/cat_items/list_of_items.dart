import 'package:cat_items/controller.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:shopify/widgets/utils/components/product_card.dart';

class ListOfItems extends StatelessWidget {
  late Function(String, String) _loadmore;
  late String _catId;
  late List<Product> _products;
  ScrollController _scrollController = ScrollController();
  ListOfItems(
      {required Function(String, String) loadmore,
      required List<Product> products,
      required String catId})
      : this._loadmore = loadmore,
        this._catId = catId,
        this._products = products;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) =>
          _handelScrollEvent(notification, _products),
      child: GridView.builder(
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
    );
  }

  bool _handelScrollEvent(
      ScrollNotification notification, List<Product> products) {
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      _loadmore(_catId, products.last.id);
    }
    return false;
  }
}
