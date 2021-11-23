import 'package:flutter/material.dart';

class UploadingPicWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 100.0,
      child: Stack(
        children: [
          SizedBox(
            child: CircularProgressIndicator(),
            height: 130.0,
            width: 130.0,
          ),
          SizedBox(
            height: 100.0,
            width: 100.0,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/Profile Image.png"),
            ),
          ),
        ],
      ),
    );
  }
}
