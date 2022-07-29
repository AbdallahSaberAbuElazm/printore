import 'package:flutter/material.dart';
import 'package:printore/views/shared/styles/colors.dart';

class BottomCenterButton extends StatelessWidget {
  final dynamic onPressed;
  final String buttonTitle;
  final bool actionRelated;
  const BottomCenterButton(
      {Key? key,
      required this.onPressed,
      required this.buttonTitle,
      required this.actionRelated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // Align(
        //   alignment: FractionalOffset.bottomCenter,
        //   child:
        Padding(
      padding: const EdgeInsets.only(top: 7, bottom: 5, right: 12, left: 12),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ButtonStyle(
            alignment: Alignment.center,
            backgroundColor: MaterialStateProperty.all(MainColor.darkGreyColor),
          ),
          child: Text(
            buttonTitle,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
          onPressed: (actionRelated == true) ? onPressed : null,
        ),
      ),
      // ),
    );
  }
}
