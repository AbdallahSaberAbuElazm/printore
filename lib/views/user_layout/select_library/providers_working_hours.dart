import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/controller/print_officce_controller.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';

class ProvidersWorkingHours extends StatelessWidget {
  final String addressTitle;
  ProvidersWorkingHours({Key? key, required this.addressTitle})
      : super(key: key);

  final _style2 = TextStyle(
      color: MainColor.darkGreyColor,
      fontSize: 11,
      fontWeight: FontWeight.w500);

  final bool today = false;
  final PrintOfficeController _printOfficeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
          backgroundColor: MainColor.darkGreyColor,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'أيام وفترات العمل',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                addressTitle,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 28,
                width: 122,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: Center(
                  child: Text(
                    Styles.formattedDate,
                    style: TextStyle(
                      color: MainColor.darkGreyColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
          content: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              height: MediaQuery.of(context).size.height / 1.7,
              child: Obx(
                () => GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(
                        _printOfficeController.listWorkingHours.length,
                        (index) {
                      if (_printOfficeController.listWorkingHours.isEmpty) {
                        return Center(
                            child: CircularProgressIndicator(
                                color: MainColor.yellowColor));
                      }
                      return Container(
                        width: 110,
                        // height: 80,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: (Styles.dayAr() ==
                                    _printOfficeController
                                        .listWorkingHours[index].dayName)
                                ? MainColor.yellowColor
                                : Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 4),
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _printOfficeController
                                      .listWorkingHours[index].dayName
                                      .toString(),
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _printOfficeController
                                      .listWorkingHours[index].workingHours
                                      .toString(),
                                  style: _style2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
              ),
            ),
          )),
    );
  }
}
