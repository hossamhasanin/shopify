import 'package:flutter/material.dart';
import 'package:app_bar/app_bar.dart';
import 'package:get/get.dart';
import 'package:shopify/widgets/app_bar/home_header.dart';

class HeaderAppBar extends StatefulWidget {
  @override
  _HeaderAppBarState createState() => _HeaderAppBarState();
}

class _HeaderAppBarState extends State<HeaderAppBar> {
  late AppBarController _appBarController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _appBarController = Get.find();
    _appBarController.getNoNotifications();
  }

  @override
  void dispose() {
    // _appBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<AppBarController>(
        init: _appBarController,
        builder: (controller) {
          debugPrint("noti is " + controller.noNotifications.value.toString());
          return HomeHeader(noNotifications: controller.noNotifications.value);
        });
  }
}
