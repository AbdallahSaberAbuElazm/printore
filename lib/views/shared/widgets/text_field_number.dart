import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printore/views/shared/styles/colors.dart';

class TextFieldNumber extends StatelessWidget {
  final String? hintName;
  final TextEditingController? controller;
  const TextFieldNumber(
      {Key? key, required this.hintName, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: MainColor.darkGreyColor,
      textDirection: TextDirection.ltr,
      controller: controller,
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MainColor.darkGreyColor)),
          fillColor: MainColor.darkGreyColor,
          focusColor: MainColor.darkGreyColor,
          hoverColor: MainColor.darkGreyColor,
          hintText: hintName,
          hintStyle: TextStyle(
            color: MainColor.darkGreyColor,
          )),
      style: Theme.of(context).textTheme.bodyText1,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ], // Only numbers can be entered
    );
  }
}
