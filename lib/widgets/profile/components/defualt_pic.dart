import 'package:flutter/material.dart';
import 'package:shopify/constants.dart';

class DefualtPic extends StatelessWidget {
  final String name;

  const DefualtPic({required this.name});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor),
      child: Center(
        child: Text(
          name[0],
          style: TextStyle(
              color: Colors.white, fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
