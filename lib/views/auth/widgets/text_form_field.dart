import 'package:flutter/material.dart';
import 'package:printore/views/shared/styles/colors.dart';

// ignore: must_be_immutable
class TextFormFieldController extends StatelessWidget {
  String? name;
  TextInputType? type;
  TextEditingController? controller;
  bool isEnabled = true;
  TextFormFieldController(
      {Key? key,
      @required this.name,
      @required this.type,
      @required this.controller,
      required this.isEnabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEnabled,
      cursorColor: MainColor.darkGreyColor,
      controller: controller,
      textDirection: TextDirection.ltr,
      keyboardType: type,
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MainColor.darkGreyColor)),
          fillColor: MainColor.darkGreyColor,
          focusColor: MainColor.darkGreyColor,
          hoverColor: MainColor.darkGreyColor,
          hintText: name,
          hintStyle: TextStyle(
            color: MainColor.darkGreyColor,
          )),
      style: Theme.of(context).textTheme.bodyText1,
      textAlign: TextAlign.right,
      validator: (value) {
        if (value!.isEmpty) {
          return 'من فضلك أدخل $name';
        }
        return null;
      },
    );
  }
}
