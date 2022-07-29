import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:printore/controller/order_controller.dart';
import 'package:printore/model/cart/cart.dart';
import 'package:printore/model/order/order.dart';
import 'package:printore/services/firestore_db.dart';
import 'package:printore/views/print_office_layout/po_printing_orders.dart';
import 'package:printore/views/print_office_layout/print_office_home.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/user_layout/file_upload/image.render.dart';
import 'dart:math' as math;
import 'package:printore/views/user_layout/file_upload/pdf_render.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;

class PrintOfficeFinishPrinting extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> user;
  final Order order;
  const PrintOfficeFinishPrinting(
      {Key? key, required this.user, required this.order})
      : super(key: key);

  @override
  State<PrintOfficeFinishPrinting> createState() =>
      _PrintOfficeFinishPrintingState();
}

class _PrintOfficeFinishPrintingState extends State<PrintOfficeFinishPrinting> {
  int pageCount = 0;
  late PdfDocument doc;
  OrderController orderController = Get.find();
  Future<bool> _onWillPop() async {
    return (await Get.off(() => PrintOfficeHome(
            recentPage: const PrintOfficePrintingOrders(),
            selectedIndex: 1))) ??
        false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Icon(
                    Icons.power_settings_new,
                    color: MainColor.darkGreyColor,
                    size: 30,
                  ),
                ),
              ],
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: MainColor.darkGreyColor,
                ),
                onPressed: () => Get.off(() => PrintOfficeHome(
                    recentPage: const PrintOfficePrintingOrders(),
                    selectedIndex: 1)),
              ),
              centerTitle: true,
              title: Text(
                'طلبات الطباعة',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 15),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _drawOrderInfo(
                              textTitle: 'عدد الملفات',
                              noOfOrders:
                                  widget.order.cartIds!.length.toString(),
                              icon: Icons.attach_file),
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: MainColor.yellowColor,
                                backgroundImage:
                                    NetworkImage(widget.user['avatarUrl']),
                                radius: 37,
                              ),
                              Text(
                                '${widget.user['first_name']} ${widget.user['last_name']}',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'الملفات الطباعة',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    FirestoreDB().updateStatusOrder(
                                        orderId:
                                            widget.order.orderId.toString(),
                                        value: true);
                                    orderController.cartOrder.clear();
                                    Get.off(() => PrintOfficeHome(
                                        recentPage:
                                            const PrintOfficePrintingOrders(),
                                        selectedIndex: 1));
                                  });
                                },
                                child: Text(
                                  'تم الطباعة',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: _drawPrintCard(),
                      ),
                    ])),
              ),
            ),
          )),
    );
  }

  Widget _drawOrderInfo(
      {required String textTitle,
      required String noOfOrders,
      required IconData icon}) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 90,
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 8,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ]),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    noOfOrders,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(icon, color: MainColor.darkGreyColor, size: 20)
                ],
              ),
              Text(
                textTitle,
                style: Theme.of(context).textTheme.bodyText1,
              )
            ]),
      ),
    );
  }

  Widget _drawPrintCard() {
    return Obx(() => ListView.builder(
        shrinkWrap: true,
        // primary: false,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: orderController.cartOrder.length,
        itemBuilder: (context, index) {
          return Container(
              margin: const EdgeInsets.only(left: 12, right: 12, bottom: 17),

              // height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 8,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ]),
              child: Column(children: [
                ListTile(
                    trailing: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 2, // space between two icons
                      children: <Widget>[
                        Transform.rotate(
                            angle: 180 * math.pi / 135,
                            child: const Icon(
                              Icons.attach_file,
                              size: 23.6,
                            )),
                        Obx(
                          () => Text(
                            '${orderController.cartOrder[index].numPages ?? ""} صفحة',
                            style: TextStyle(
                                color: MainColor.darkGreyColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                    contentPadding: const EdgeInsets.only(
                        top: 13, bottom: 13, right: 20, left: 20),
                    leading: Icon(
                      Icons.file_open,
                      size: 50,
                      color: MainColor.darkGreyColor,
                    ),
                    title: Obx(
                      () => Text(
                        orderController.cartOrder[index].fileName ?? "",
                        style: TextStyle(
                            color: MainColor.darkGreyColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.date_range_outlined,
                          size: 16,
                          color: MainColor.darkGreyColor,
                        ),
                        Obx(
                          () => Text(
                            orderController.cartOrder[index].uploadAt ?? "",
                            style: TextStyle(
                                color: MainColor.darkGreyColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    )),
                _drawPrintingOptionButtons(
                    context, orderController.cartOrder[index], index)
              ]));
        }));
  }

  // printing options for files
  Widget _drawPrintingOptionButtons(
      BuildContext context, Cart specificCart, int index) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 9, bottom: 9),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 8,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ]),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FlutterSwitch(
            width: 45.0,
            height: 24.0,
            valueFontSize: 0.0,
            toggleSize: 27.0,
            value: specificCart.finished!,
            activeColor: MainColor.darkGreyColor,
            toggleColor: MainColor.yellowColor,
            inactiveToggleColor: Colors.white70,
            borderRadius: 30.0,
            padding: 1.5,
            showOnOff: true,
            onToggle: (val) {
              setState(() {
                FirestoreDB().updateStatusCart(
                    userId: widget.user['userId'],
                    cartId: widget.order.cartIds![index],
                    value: val);
                orderController.cartOrder[index].finished = val;
              });
            },
          ),
          InkWell(
            onTap: () async {
              var data = await http
                  .get(Uri.parse(specificCart.downloadUrl.toString()));
              await Printing.layoutPdf(onLayout: (_) => data.bodyBytes);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'طباعة',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  width: 7,
                ),
                Icon(
                  Icons.print,
                  color: MainColor.darkGreyColor,
                  size: 23,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              String extension = specificCart.fileExtension.toString();
              if (extension == '.jpg' ||
                  extension == '.jpeg' ||
                  extension == '.webp' ||
                  extension == '.png') {
                Get.to(() => ImageRender(
                      tag: specificCart.fileName.toString(),
                      downloadUrl: specificCart.downloadUrl.toString(),
                    ));
              } else {
                Get.to(() => PdfRender(
                    fileName: specificCart.fileName.toString(),
                    url: specificCart.downloadUrl.toString()));
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'عرض',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  width: 7,
                ),
                Icon(
                  Icons.remove_red_eye_outlined,
                  color: MainColor.darkGreyColor,
                  size: 23,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  getFilePages(String url) async {
    doc = await PdfDocument.openAsset(url);
    return doc.pageCount;
  }

// button has text and icon
  Widget optionButton(
      {required String btnName,
      required Color btnColor,
      required IconData icon,
      dynamic onPressedBtn}) {
    return Container(
      width: 120,
      height: 40,
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(btnColor),
          ),
          onPressed: onPressedBtn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                btnName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                width: 7,
              ),
              Icon(
                icon,
                color: Colors.white,
                size: 23,
              ),
            ],
          )),
    );
  }
}
