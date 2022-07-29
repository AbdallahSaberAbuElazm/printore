import 'package:flutter/material.dart';
import 'package:printore/views/shared/styles/colors.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  const PasswordFormField(
      {Key? key, @required this.controller, @required this.hintText})
      : super(key: key);

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: MainColor.darkGreyColor,
      controller: widget.controller,
      validator: (val) =>
          (val != null && val.length < 6) ? 'كلمة المرور اقل من 6 احرف' : null,
      textDirection: TextDirection.ltr,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        fillColor: MainColor.darkGreyColor,
        focusColor: MainColor.darkGreyColor,
        hoverColor: MainColor.darkGreyColor,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: MainColor.darkGreyColor)),
        hintText: widget.hintText,
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            (_passwordVisible == true)
                ? Icons.visibility
                : Icons.visibility_off,
            color: MainColor.darkGreyColor,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      obscureText: !_passwordVisible,
      enableSuggestions: false,
      autocorrect: false,
      style: Theme.of(context).textTheme.bodyText1,
      textAlign: TextAlign.right,
    );
  }
}
