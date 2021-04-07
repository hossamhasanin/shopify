import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopify/widgets/app_bar/app_bar.dart';
import 'package:shopify/widgets/notifications/list_of_notifications.dart';
import 'package:shopify/widgets/utils/helpers.dart';
import 'package:models/notification.dart' as N;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    N.Notification.notification.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(20)),
        HeaderAppBar(),
        SizedBox(height: getProportionateScreenWidth(10)),
        Obx(() {
          if (N.Notification.notification.isEmpty) {
            return Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(250)),
                Center(child: Text("No notifications yet")),
              ],
            );
          } else {
            return Expanded(
              child:
                  NotificationsList(notifications: N.Notification.notification),
            );
          }
        })
      ],
    ));
  }
}
