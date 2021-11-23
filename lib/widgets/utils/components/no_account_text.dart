import 'package:flutter/material.dart';
import 'package:shopify/constants.dart';
import 'package:shopify/widgets/utils/helpers.dart';

class NoAccountText extends StatelessWidget {
  final Function() onTap;
  const NoAccountText({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don’t have an account? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            "Sign Up",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
