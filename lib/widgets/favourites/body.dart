import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopify/constants.dart';
import 'package:shopify/widgets/app_bar/app_bar.dart';
import 'package:shopify/widgets/cat_items/list_of_items.dart';
import 'package:shopify/widgets/utils/helpers.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late FavoritesController _controller;

  @override
  void initState() {
    super.initState();

    _controller = Get.find();

    _controller.getFavorites("");
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
          child: GetX<FavoritesController>(
            init: _controller,
            builder: (controller) {
              var viewstate = controller.viewState.value;
              if (viewstate!.favorites.length == 0) {
                return Center(
                    child: Text(
                  "There is no favorites in this section yet",
                  style: TextStyle(color: Colors.grey),
                ));
              } else if (viewstate.error.isNotEmpty) {
                return Center(
                    child: Text(
                  viewstate.error,
                  style: TextStyle(color: kPrimaryColor),
                ));
              } else if (viewstate.favorites.length > 0) {
                return ListOfItems(
                  refresh: () {
                    debugPrint("I am refreshing");
                    return controller.getFavorites("");
                    //return Future.value();
                  },
                  products: viewstate.favorites,
                  loadmore: (String lastId) => _controller.getFavorites(lastId),
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
