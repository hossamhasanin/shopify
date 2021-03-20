import 'package:cat_items/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:models/models.dart';
import 'package:shopify/constants.dart';
import 'package:shopify/widgets/cat_items/list_of_items.dart';
import 'package:shopify/widgets/utils/components/product_card.dart';

class Body extends StatefulWidget {
  Category cat;
  Body({required this.cat});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late CatItemsController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = Get.find();
    _controller.getItems(widget.cat.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GetX<CatItemsController>(
      init: _controller,
      builder: (controller) {
        var viewstate = controller.viewstate.value;
        if (viewstate!.items.length == 0) {
          return Center(
              child: Text(
            "There is no products in this section yet",
            style: TextStyle(color: Colors.grey),
          ));
        } else if (viewstate.error.isNotEmpty) {
          return Center(
              child: Text(
            viewstate.error,
            style: TextStyle(color: kPrimaryColor),
          ));
        } else if (viewstate.items.length > 0) {
          return ListOfItems(
            refresh: controller.refreshItems(widget.cat.id),
            products: viewstate.items,
            loadmore: (String lastId) =>
                _controller.loadMore(widget.cat.id, lastId),
            catId: widget.cat.id,
          );
        } else if (viewstate.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container();
        }
      },
    ));
  }
}
