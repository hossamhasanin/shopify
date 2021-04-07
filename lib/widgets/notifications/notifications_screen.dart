import 'package:flutter/material.dart';
import 'package:shopify/widgets/notifications/body.dart';

class NotificationsScreen extends StatelessWidget {
  static String routeName = "/notifications";

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Body());
  }
}
