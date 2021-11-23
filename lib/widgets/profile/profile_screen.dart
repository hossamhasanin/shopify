import 'package:flutter/material.dart';
import 'package:shopify/widgets/profile/components/body.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Body(),
    );
  }
}
