import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopify/constants.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    required this.text,
    required this.icon,
    required this.press,
  });

  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          primary: Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: kPrimaryColor,
              width: 22,
            ),
            SizedBox(width: 20),
            Expanded(
                child: Text(
              text,
              style: TextStyle(color: kPrimaryColor),
            )),
            Icon(Icons.arrow_forward_ios, color: kPrimaryColor),
          ],
        ),
      ),
    );
  }
}
