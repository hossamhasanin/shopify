import 'dart:io';

import 'package:authentication_x/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/User.dart';
import 'package:shopify/widgets/auth/AuthUi.dart';
import 'package:shopify/widgets/profile/components/change_account_details.dart';
import 'package:shopify/widgets/utils/components/uploading_pic_widget.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  AuthController _authController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _authController.user.listen((user) {
      _authController.userImageViewState.value =
          _authController.userImageViewState.value!.copy(user: user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Obx(() {
            var state = _authController.userImageViewState.value!;
            return ProfilePic(
              image: state.user!.image != null ? state.user!.image! : "none",
              name: state.user!.username.isNotEmpty
                  ? state.user!.username
                  : "Error",
              uploading: state.uploading,
              pickedImage: state.pickedImage,
              uploadImage: (File image) async {
                await _authController.uploadFile(image);
              },
            );
          }),

          // UploadingPicWidget(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () async {
              User user = await Get.to(ChangeAccountDetails(
                  user: _authController.userImageViewState.value!.user!));
              await _authController.updateProfile(user);
            },
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () async {
              await _authController.logout();
              Get.off(AuthUi());
            },
          ),
        ],
      ),
    );
  }
}
