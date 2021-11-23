import 'package:flutter/material.dart';
import 'package:app_bar/app_bar.dart';
import 'package:get/get.dart';
import 'package:shopify/widgets/app_bar/home_header.dart';
import 'package:shopify/widgets/utils/helpers.dart';

class HeaderAppBar extends StatefulWidget {
  @override
  HeaderAppBarState createState() => HeaderAppBarState();
}

class HeaderAppBarState extends State<HeaderAppBar> {
  late AppBarController _appBarController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _appBarController = Get.find();
    // _appBarController.getNoNotifications();
    _appBarController.getNumCartProduct();
  }

  @override
  void dispose() {
    // _appBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeHeader();
  }
}
