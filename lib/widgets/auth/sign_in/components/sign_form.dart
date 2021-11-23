import 'package:authentication_x/AuthController.dart';
import 'package:authentication_x/validators/FormValidator.dart';
import 'package:authentication_x/validators/ValidationErrors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopify/widgets/utils/components/custom_surfix_icon.dart';
import 'package:shopify/widgets/utils/components/default_button.dart';
import 'package:shopify/widgets/utils/helpers.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  FormValidator validator = Get.find();
  AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              GestureDetector(
                // onTap: () => Navigator.pushNamed(
                //     context, "ForgotPasswordScreen.routeName"),
                onTap: () {},
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                hideKeyboard(context);
                //Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                controller.login(email!, password!);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      validator: (password) {
        var isValid = validator.isPasswordValid(password);
        if (isValid == PassWordErrors.PasswordEmpty) {
          return "You have to enter password";
        } else if (isValid == PassWordErrors.PassowrdTooShort) {
          return "Your password is too short";
        } else if (isValid ==
            PassWordErrors.PasswordMustContainAtLeastOnLetter) {
          return "Your password has to contain at least one letter";
        } else if (isValid == PassWordErrors.PasswordNotContainsSpecialChar) {
          return "Your password should contain special characters";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      validator: (email) {
        var isValid = validator.isEmailValid(email);
        if (isValid == EmailErrors.EmailEmpty) {
          return "Don't leave the email empty";
        } else if (isValid == EmailErrors.EmailContainsNotValidChar) {
          return "You entered not valid chars in the email";
        } else if (isValid == EmailErrors.EmailDoesNotContailAt) {
          return "You should type the email correctly";
        } else if (isValid == EmailErrors.EmailTooShort) {
          return "Your email is too short to become an email";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
