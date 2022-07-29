import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:printore/controller/order_controller.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/print_office_layout/po_completed_orders.dart';
import 'package:printore/views/print_office_layout/po_home_page.dart';
import 'package:printore/views/print_office_layout/po_printing_orders.dart';
import 'package:printore/views/print_office_layout/qr_code_scanner.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/widgets/printing_officer_navigation_drawer.dart';
import 'package:provider/provider.dart';

class PrintOfficeHome extends StatefulWidget {
  Widget recentPage;
  int selectedIndex;
  PrintOfficeHome(
      {Key? key, required this.recentPage, required this.selectedIndex})
      : super(key: key);

  @override
  State<PrintOfficeHome> createState() => _PrintOfficeHomeState();
}

class _PrintOfficeHomeState extends State<PrintOfficeHome> {
  List<Widget> pages = [
    const PrintOfficeHomePage(),
    const PrintOfficePrintingOrders(),
    const PrintOfficeCompletedOrders(),
    const QRCodeScanner()
  ];
  OptionProvider? option;
  void updateTabSelection(int index) {
    setState(() {
      widget.selectedIndex = index;
      widget.recentPage = pages[index];
    });
  }

  @override
  void initState() {
    Get.find<OrderController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    option = Provider.of<OptionProvider>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: AdvancedDrawer(
            backdropColor: const Color.fromARGB(255, 236, 239, 241),
            controller: option!.advancedDrawerController,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 80),
            animateChildDecoration: true,
            rtlOpening: true,
            // openScale: 1.0,
            disabledGestures: false,
            childDecoration: const BoxDecoration(
              // NOTICE: Uncomment if you want to add shadow behind the page.
              // Keep in mind that it may cause animation jerks.
              // boxShadow: <BoxShadow>[
              //   BoxShadow(
              //     color: Colors.black12,
              //     blurRadius: 0.0,
              //   ),
              // ],
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            drawer: const PrintingOfficerNavigationDrawer(),
            child: Scaffold(
              body: widget.recentPage,
              bottomNavigationBar: BottomAppBar(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _drawIcon(
                            icon: widget.selectedIndex == 0
                                ? Icons.home
                                : Icons.home_outlined,
                            index: 0,
                            name: 'الصفحة الرئيسية'),
                        _drawIcon(
                            icon: widget.selectedIndex == 1
                                ? Icons.format_list_bulleted
                                : Icons.format_list_bulleted_rounded,
                            index: 1,
                            name: 'طلبات الطباعة'),
                        //to leave space in between the bottom app bar items and below the FAB

                        _drawIcon(
                            icon: widget.selectedIndex == 2
                                ? Icons.playlist_add_check
                                : Icons.playlist_add_check_rounded,
                            index: 2,
                            name: 'الطلبات المكتملة'),
                        _drawIcon(
                            icon: widget.selectedIndex == 3
                                ? Icons.qr_code
                                : Icons.qr_code_2_rounded,
                            index: 3,
                            name: 'قارئ الكود'),
                      ],
                    ),
                  ),
                ),
                //to add a space between the FAB and BottomAppBar
                shape: const CircularNotchedRectangle(),
                //color of the BottomAppBar
                color: Colors.white,
              ),
            )));
  }

  //icon for bottom navigation bar
  Widget _drawIcon(
      {required IconData icon, required int index, required String name}) {
    return SizedBox(
      width: 90,
      height: 65,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            autofocus: true,
            //update the bottom app bar view each time an item is clicked
            onPressed: () {
              updateTabSelection(index);
            },
            iconSize: 32.0,
            icon: Icon(
              icon,
              //darken the icon if it is selected or else give it a different color
              color: widget.selectedIndex == index
                  ? MainColor.yellowColor
                  : MainColor.darkGreyColor,
            ),
            focusColor: Colors.white,
            splashColor: MainColor.yellowColor,
            hoverColor: Colors.white,
          ),
          Transform.translate(
            offset: const Offset(0, -6),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 8,
                color: widget.selectedIndex == index
                    ? MainColor.yellowColor
                    : MainColor.darkGreyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
