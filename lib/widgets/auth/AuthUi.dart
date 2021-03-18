import 'package:authentication_x/authentication_x.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopify/widgets/all_items/AllItemsScreen.dart';
import 'package:shopify/widgets/auth/login_success/login_success_screen.dart';
import 'package:shopify/widgets/auth/sign_in/sign_in_screen.dart';
import 'package:shopify/widgets/auth/sign_up/sign_up_screen.dart';
import 'package:shopify/widgets/utils/helpers.dart';

class AuthUi extends StatelessWidget {
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return AuthWidget(
      loginWidget: SignInScreen(),
      signupWidget: SignUpScreen(),
      onLoginState: (state) {
        if (state.isLogging) {
          _showLoadingDialog(context);
        } else if (state.isLogged) {
          Get.off(LoginSuccessScreen());
        } else if (state.error != null) {
          AwesomeDialog(
              context: context,
              title: "Error !",
              desc: state.error.toString(),
              dialogType: DialogType.ERROR)
            ..show();
        }
      },
      onSignupState: (state) {
        if (state.isSigning) {
          _showLoadingDialog(context);
        } else if (state.isSigned) {
          // go to set settings screen if needed or to the home screen
          Get.offNamed(AllItemsScreen.routeName);
        } else if (state.error != null) {
          AwesomeDialog(
              context: context,
              title: "Error !",
              desc: state.error.toString(),
              dialogType: DialogType.ERROR)
            ..show();
        }
      },
    );
  }

  _showLoadingDialog(BuildContext context) {
    showCustomDialog(
        context: context,
        title: "Wait a bit ...",
        children: [Center(child: CircularProgressIndicator())],
        dissmissable: false);
  }
}
