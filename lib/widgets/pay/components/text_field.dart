import 'package:flutter/material.dart';

class CustomedTextField extends StatelessWidget {
  final String _hintText;
  final TextEditingController _textEditingController;
  final TextInputType _textInputType;

  const CustomedTextField(
      {required String hintText,
      required TextEditingController textEditingController,
      required TextInputType textInputType})
      : this._hintText = hintText,
        this._textEditingController = textEditingController,
        this._textInputType = textInputType;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      keyboardType: _textInputType,
      decoration: InputDecoration(
          hintText: _hintText,
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.green, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10.0)),
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.grey, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10.0))),
    );
  }
}
