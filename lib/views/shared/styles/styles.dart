import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:intl/date_symbol_data_local.dart';

class Styles {
  static DateTime now = DateTime.now();
  static String formattedDate = DateFormat(' kk:mm - yyyy-MM-dd').format(now);
  static String formateddDay = DateFormat('EEEE').format(now);
  static List weekDays = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة'
  ];
  static String monthAr() {
    initializeDateFormatting("ar_SA", null);
    var formatter = DateFormat.MMM("ar_SA");
    return formatter.format(now);
  }

  static String dayAr() {
    initializeDateFormatting("ar_SA", null);
    var formatter = DateFormat.E("ar_SA");
    return formatter.format(now);
  }

  static Widget loginButton(
      BuildContext context, String name, dynamic onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(name,
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.right),
    );
  }

// registeration button
  static Widget registerButton(
      BuildContext context, String name, dynamic onPressed) {
    return TextButton(
        onPressed: onPressed,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(name,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.right),
          Icon(
            Icons.arrow_back_ios_new,
            color: MainColor.darkGreyColor,
            size: 16,
          )
        ]));
  }

// app logo
  static Widget logo() {
    return SizedBox(
      width: 70,
      height: 60,
      child: Center(
        child: Image.asset(
          'assets/images/printore.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

//App Bar text
  static Widget appBarText(String name, BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
    );
  }

//theme text for detail data
  static TextStyle detailTheme = TextStyle(
      color: MainColor.darkGreyColor,
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
      fontSize: 15.0);

//Draw Stepper
  static Widget drawContainerOfStepper({required Color color}) {
    return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(9)),
            color: color,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 8,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ]));
  }

  static Widget drawLineOfStepper(
      {required BuildContext context, required Color color}) {
    return Container(
        width: MediaQuery.of(context).size.width / 2.611,
        height: 5,
        decoration: BoxDecoration(color: color, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 8,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ]));
  }

  static Widget drawStepperNameRow({required BuildContext context}) {
    return Padding(
        padding: const EdgeInsets.only(top: 9, left: 12, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Styles.addStepperName(context: context, stepperName: 'الملفات'),
            Styles.addStepperName(
                context: context, stepperName: 'خيارات الطباعة'),
            Styles.addStepperName(context: context, stepperName: 'الدفع')
          ],
        ));
  }

// stepper name
  static Widget addStepperName(
      {required BuildContext context, required String stepperName}) {
    return Text(
      stepperName,
      style: Theme.of(context).textTheme.bodyText1,
    );
  }

// alert for delete file
  static Widget alertDeletingItem(
      {required BuildContext context, required dynamic deleteFile}) {
    return AlertDialog(
      backgroundColor: MainColor.darkGreyColor,
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform.translate(
              offset: const Offset(0, -78),
              child: SizedBox(
                width: 180,
                height: 120,
                child: Image.asset('assets/images/Open-folder-delete-icon.png'),
              ),
            ),
            Transform.translate(
                offset: const Offset(0, -50),
                child: Column(
                  children: [
                    Text("هل أنت مُتأكد؟",
                        style: Theme.of(context).textTheme.bodyText2),
                    const Text("من حذف هذه الملف",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ],
                )),
          ]),
      actions: <Widget>[
        Transform.translate(
          offset: const Offset(0, -20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.only(
                        right: 25, left: 25, top: 4, bottom: 4)),
                    backgroundColor:
                        MaterialStateProperty.all(MainColor.yellowColor),
                    alignment: Alignment.center),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'إلغاء',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.only(
                        right: 25, left: 25, top: 4, bottom: 4)),
                    backgroundColor:
                        MaterialStateProperty.all(MainColor.yellowColor),
                    alignment: Alignment.center),
                onPressed: deleteFile,
                child: Text(
                  'تأكيد',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  // alert for upload file
  static Widget alertUploadFile(
      {required BuildContext context, required dynamic uploadFile}) {
    return AlertDialog(
      backgroundColor: MainColor.darkGreyColor,
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform.translate(
              offset: const Offset(0, -78),
              child: SizedBox(
                width: 240,
                height: 140,
                child: Image.asset('assets/images/output-onlinegiftools.png'),
              ),
            ),
            Transform.translate(
                offset: const Offset(0, -50),
                child: Column(
                  children: [
                    Text("هل أنت مُتأكد؟",
                        style: Theme.of(context).textTheme.bodyText2),
                    const Text("من رفع هذه الملفات",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ],
                )),
          ]),
      actions: <Widget>[
        Transform.translate(
          offset: const Offset(0, -20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.only(
                        right: 25, left: 25, top: 4, bottom: 4)),
                    backgroundColor:
                        MaterialStateProperty.all(MainColor.yellowColor),
                    alignment: Alignment.center),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: Text(
                  'إلغاء',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.only(
                        right: 25, left: 25, top: 4, bottom: 4)),
                    backgroundColor:
                        MaterialStateProperty.all(MainColor.yellowColor),
                    alignment: Alignment.center),
                onPressed: uploadFile,
                child: Text(
                  'تأكيد',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
