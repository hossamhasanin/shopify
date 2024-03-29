import 'package:flutter/material.dart';
import 'package:shopify/constants.dart';
import 'package:shopify/widgets/utils/helpers.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton(
      {required this.text, required this.press, this.color = kPrimaryColor});
  final String text;
  final Function() press;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            primary: color),
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
