import 'package:flutter/material.dart';
import 'package:printore/provider/option_provider.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:printore/views/shared/styles/colors.dart';
import 'package:get/get.dart';
import 'package:printore/controller/paper_price_controller.dart';
import 'package:provider/provider.dart';

class Utils {
  static final PaperPriceController _paperPriceController = Get.find();
  static snackBar({required BuildContext context, required String? msg}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg!,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      backgroundColor: Colors.white,
    ));
  }

  static String createCryptoRandomString([int length = 32]) {
    final _random = math.Random.secure();
    var values = List<int>.generate(length, (index) => _random.nextInt(256));
    return base64Url.encode(values);
  }

  static showDialogOnWillPop({required BuildContext context}) async {
    return showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            'هل انت متأكد ؟',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          content: Text('هل تريد الخروج من التطبيق ؟',
              style: Theme.of(context).textTheme.headline6),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('لا',
                  style: TextStyle(
                      color: MainColor.yellowColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('نعم',
                  style: TextStyle(
                      color: MainColor.yellowColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
            ),
          ],
        ),
      ),
    );
  }

  static getPaperPrice({required BuildContext context}) {
    OptionProvider option = Provider.of<OptionProvider>(context, listen: false);
    _paperPriceController.getPaperPrice(
      paperColor: option.colorSelected,
      paperSize: option.sizeSelected,
      paperType: option.paperTypeSelected,
    );
  }
}
