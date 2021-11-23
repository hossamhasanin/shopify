import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/models.dart';
import './body.dart';

class CatItemsScreen extends StatelessWidget {
  static String routeName = "/cat_items";
  Category? cat = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        cat: cat,
      ),
    );
  }
}
