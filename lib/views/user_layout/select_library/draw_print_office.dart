import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/controller/cart_controller.dart';
import 'package:printore/controller/print_officce_controller.dart';
import 'package:printore/model/service_providers/print_office.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/widgets/rating_builder.dart';
import 'package:printore/views/user_layout/select_library/providers_working_hours.dart';

class DrawPrintOffice extends StatefulWidget {
  // final int? index;
  final printOfficeController;
  const DrawPrintOffice({
    Key? key,
    // required this.index,
    required this.printOfficeController,
  }) : super(key: key);
  static const IconData directions =
      IconData(0xe1d1, fontFamily: 'MaterialIcons', matchTextDirection: true);

  @override
  State<DrawPrintOffice> createState() => _DrawPrintOfficeState();
}

class _DrawPrintOfficeState extends State<DrawPrintOffice> {
  final PrintOfficeController _printOfficeController = Get.find();
  final CartController _cartController = Get.find();
  @override
  void initState() {
    super.initState();
  }

  final _style = const TextStyle(
      color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500);

  final _style2 = const TextStyle(
      color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () {
            _printOfficeController
                .updateDay(widget.printOfficeController['printOfficeName']);
            _printOfficeController.updatePrintOffice(PrintOffice(
                id: widget.printOfficeController['printOfficeId'],
                printOfficeName:
                    widget.printOfficeController['printOfficeName'],
                printOfficeUrl: widget.printOfficeController['printOfficeUrl'],
                printOfficeAddress:
                    widget.printOfficeController['printOfficeAddress'],
                printOfficeRating:
                    widget.printOfficeController['rating'].toDouble(),
                city: widget.printOfficeController['city'],
                governorate: widget.printOfficeController['governorate'],
                status: true,
                latitude: widget.printOfficeController['latitude'],
                longitude: widget.printOfficeController['longitude']));
          },
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 12, right: 12, bottom: 11),
                padding: const EdgeInsets.only(left: 12, right: 12, top: 4),
                // height: 195,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: (_printOfficeController.office ==
                            widget.printOfficeController['printOfficeName'])
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                                const Color.fromARGB(255, 70, 96, 110),
                                MainColor.yellowColor
                              ])
                        : null,
                    color: (_printOfficeController.office ==
                            widget.printOfficeController['printOfficeName'])
                        ? null
                        : MainColor.darkGreyColor,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 8,
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ]),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 11),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 88,
                                  width: 75,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      widget.printOfficeController[
                                          'printOfficeUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  padding: const EdgeInsets.only(
                                      right: 12, left: 8, bottom: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          widget.printOfficeController[
                                              'printOfficeName'],
                                          style: _style),
                                      Text(
                                          widget.printOfficeController[
                                              'printOfficeAddress'],
                                          style: _style),
                                      Stack(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '(${widget.printOfficeController['rating']})',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              RatingBuilder(
                                                rating: widget
                                                    .printOfficeController[
                                                        'rating']
                                                    .toDouble(),
                                                itemSize: 18,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            child: Text(
                                              'kkkkkkkkkkkk',
                                              style: TextStyle(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(
                                  DrawPrintOffice.directions,
                                  color: Colors.white,
                                  size: 34,
                                ),
                                Text(
                                  'الإتجاهات',
                                  style: _style2,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                // Text(
                                //   'خلال 10 دقيقة',
                                //   style: _style2,
                                // ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 25),
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                _printOfficeController.getWorkingHours(
                                    city: widget.printOfficeController['city'],
                                    governorate: widget
                                        .printOfficeController['governorate'],
                                    printOfficeId:
                                        widget.printOfficeController.id);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ProvidersWorkingHours(
                                          addressTitle:
                                              widget.printOfficeController[
                                                  'printOfficeName']);
                                    });
                              },
                              child: Transform.translate(
                                offset: const Offset(0, -10),
                                child: Container(
                                    height: 40,
                                    width: 77,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6))),
                                    child: Center(
                                      child: Text(
                                        'ساعات العمل',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: MainColor.darkGreyColor,
                                            fontSize: 9),
                                      ),
                                    )),
                              ),
                            ),
                            Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 14),
                                  width:
                                      MediaQuery.of(context).size.width / 1.9,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 40),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Icon(
                                          Icons.money_outlined,
                                          color: MainColor.darkGreyColor,
                                          size: 18,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'تكلفة الطباعة',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: Transform.translate(
                                    //95
                                    offset: Offset(
                                        -(MediaQuery.of(context).size.width /
                                            2.8),
                                        -28),
                                    child: Container(
                                      width: 66,
                                      height: 62,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                '${_cartController.priceCart.value}',
                                                style: TextStyle(
                                                    color:
                                                        MainColor.darkGreyColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Transform.translate(
                                              offset: const Offset(0, -6),
                                              child: Text('جنيه',
                                                  style: TextStyle(
                                                      color: MainColor
                                                          .darkGreyColor,
                                                      fontSize: 9)),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ));
  }
}
