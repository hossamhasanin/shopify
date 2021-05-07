import 'package:flutter/material.dart';
import 'package:shopify/widgets/favourites/body.dart';

class FavouritesScreen extends StatelessWidget {
  static String routeName = "/favorites";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
