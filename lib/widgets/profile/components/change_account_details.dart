import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/User.dart';
import 'package:shopify/widgets/pay/components/text_field.dart';
import 'package:shopify/widgets/utils/components/default_button.dart';
import 'package:shopify/widgets/utils/helpers.dart';

class ChangeAccountDetails extends StatefulWidget {
  final User user;

  const ChangeAccountDetails({required this.user});

  @override
  _ChangeAccountDetailsState createState() => _ChangeAccountDetailsState();
}

class _ChangeAccountDetailsState extends State<ChangeAccountDetails> {
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile data"),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          Text("Username :", style: TextStyle(color: Colors.black)),
          SizedBox(height: getProportionateScreenHeight(10)),
          CustomedTextField(
            hintText: "Your username ...",
            textEditingController: _usernameController,
            textInputType: TextInputType.text,
          ),
          Text("Email :", style: TextStyle(color: Colors.black)),
          SizedBox(height: getProportionateScreenHeight(10)),
          FocusScope(
            node: FocusScopeNode(),
            child: CustomedTextField(
              hintText: "Your Email ...",
              textEditingController: _emailController,
              textInputType: TextInputType.text,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          Text("I am a ... ?", style: TextStyle(color: Colors.black)),
          SizedBox(height: getProportionateScreenHeight(10)),
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              ListTile(
                leading: Radio<int>(
                  value: 1,
                  groupValue: widget.user.gender ?? -1,
                  onChanged: (value) {
                    widget.user.gender = value;
                  },
                ),
                title: Text("Man"),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              ListTile(
                leading: Radio<int>(
                  value: 0,
                  groupValue: widget.user.gender ?? -1,
                  onChanged: (value) {
                    widget.user.gender = value;
                  },
                ),
                title: Text("Woman"),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              Center(
                  child: DefaultButton(
                      text: "Done",
                      press: () {
                        widget.user.username = _usernameController.text;
                        widget.user.email = _emailController.text;

                        Get.back(result: widget.user);
                      }))
            ],
          )
        ],
      ),
    );
  }
}
