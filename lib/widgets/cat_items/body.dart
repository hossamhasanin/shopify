import 'package:cat_items/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:models/models.dart';
import 'package:shopify/constants.dart';
import 'package:shopify/datasources/database/CashDatabase.dart';
import 'package:shopify/datasources/database/FirebaseDataSource.dart';
import 'package:shopify/widgets/app_bar/app_bar.dart';
import 'package:shopify/widgets/cat_items/list_of_items.dart';
import 'package:shopify/widgets/utils/helpers.dart';

class Body extends StatefulWidget {
  Category? cat;
  Body({this.cat});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late CatItemsController _controller;
  late String catId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    catId = widget.cat == null ? "" : widget.cat!.id;
    debugPrint("catId " + catId);
    _controller = Get.put(CatItemsController(
        cashDatasource: Get.find<CashDatabase>(),
        networkDatasource: Get.find<FirebaseDataSource>()))!;
    if (_controller.viewstate.value!.items.length == 0)
      _controller.getItems(catId);
    debugPrint("init cat items");
  }

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
    debugPrint("dispose cat items");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(20)),
        HeaderAppBar(),
        SizedBox(height: getProportionateScreenWidth(10)),
        Expanded(
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
                  refresh: () {
                    debugPrint("I am refreshing");
                    return controller.refreshItems(catId);
                    //return Future.value();
                  },
                  products: viewstate.items,
                  loadmore: (String lastId) =>
                      _controller.loadMore(catId, lastId),
                );
              } else if (viewstate.loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    ));
  }
}
