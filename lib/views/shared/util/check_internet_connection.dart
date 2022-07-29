import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printore/views/shared/styles/colors.dart';

class CheckInternetConnection {
  static Future CheckUserConnection({required BuildContext context}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty && result[0].rawAddress.isEmpty) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) =>
                _alertForNoInternetConnection(context: context));
      }
    } on SocketException catch (_) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) =>
              _alertForNoInternetConnection(context: context));
    }
  }

  static Widget _alertForNoInternetConnection({required BuildContext context}) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: MainColor.darkGreyColor,
          content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.translate(
                  offset: const Offset(0, -81),
                  child: SizedBox(
                    width: 220,
                    height: 150,
                    child:
                        Image.asset('assets/images/no_internet_connection.png'),
                  ),
                ),
                Transform.translate(
                    offset: const Offset(0, -50),
                    child: Column(
                      children: [
                        Text("لا يوجد إتصال بالإنترنت",
                            style: Theme.of(context).textTheme.bodyText2),
                        const Text(
                            "أنت غير متصل بالإنترنت حاليا.تأكد من وجود اتصال بالإنترنت",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                      ],
                    )),
              ]),
          actions: <Widget>[
            Transform.translate(
              offset: const Offset(0, -20),
              child: Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.only(
                          right: 25, left: 25, top: 4, bottom: 4)),
                      backgroundColor:
                          MaterialStateProperty.all(MainColor.yellowColor),
                      alignment: Alignment.center),
                  onPressed: () async {
                    try {
                      final result = await InternetAddress.lookup('google.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        Navigator.of(context).pop();
                      }
                    } on SocketException catch (_) {}
                  },
                  child: Text(
                    'حاول مجددا',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
