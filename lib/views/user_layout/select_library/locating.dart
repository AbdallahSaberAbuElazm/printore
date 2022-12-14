import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:printore/controller/location_controller.dart';
import 'package:printore/controller/print_officce_controller.dart';
import 'package:printore/model/service_providers/print_office.dart';
import 'package:printore/views/auth/widgets/text_form_field.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/util/util.dart';
import 'package:printore/views/shared/widgets/alert_dialog_address.dart';
import 'package:printore/views/shared/widgets/button_center_button.dart';
import 'package:printore/views/shared/widgets/cart_shopping_icon.dart';
import 'package:printore/views/user_layout/home/home.dart';
import 'package:printore/views/user_layout/home/upload_page.dart';
import 'package:printore/views/user_layout/order/order_summary.dart';
import 'package:printore/views/user_layout/select_library/draw_map_print_office.dart';
import 'package:printore/views/user_layout/select_library/draw_print_office.dart';

class Locating extends StatefulWidget {
  const Locating({
    Key? key,
  }) : super(key: key);

  @override
  State<Locating> createState() => _LocatingState();
}

class _LocatingState extends State<Locating> {
  final _governorateController = TextEditingController();
  final _cityController = TextEditingController();
  bool _switchVal = false;
  int indexSelected = 0;
  int printOffice = 0;
  final LocationController _locationController = Get.find<LocationController>();
  final PrintOfficeController _printOfficeController =
      Get.find<PrintOfficeController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _governorateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: MainColor.darkGreyColor,
          title: Styles.appBarText('?????????? ????????????', context),
          centerTitle: true,
          leading: CartShoppingIcon(),
          actions: [
            Padding(
                padding: const EdgeInsets.only(left: 8),
                child: IconButton(
                  onPressed: () => Get.to(() =>
                      Home(recentPage: const UploadPage(), selectedIndex: 2)),
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 26,
                  ),
                )),
          ],
        ),
        bottomSheet: Obx(() => BottomCenterButton(
              buttonTitle: '??????????????',
              onPressed: () {
                
                Get.to(() => OrderSummary());
              },
              actionRelated: (_printOfficeController.office.value.isNotEmpty)
                  ? true
                  : false,
            )),
        body: ListView(children: [
          _drawStepper(context),
          Styles.drawStepperNameRow(context: context),
          _selectAddress(context: context),
          _determineDelivery(),
          (printOffice >= 2)
              ? _determinePrintOffice()
              : const SizedBox.shrink(),
          (printOffice >= 2) ? _drawPrintOffice() : const SizedBox.shrink(),
        ]),
      ),
    );
  }

  // draw stepper
  Widget _drawStepper(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 24, right: 12, left: 12),
        child: Row(
          children: [
            Styles.drawContainerOfStepper(color: MainColor.yellowColor),
            Styles.drawLineOfStepper(
                color: MainColor.yellowColor, context: context),
            Styles.drawContainerOfStepper(
              color: MainColor.yellowColor,
            ),
            Styles.drawLineOfStepper(
                color: MainColor.yellowColor, context: context),
            Styles.drawContainerOfStepper(
              color: MainColor.yellowColor,
            ),
          ],
        ));
  }

// select address to detect service providers
  Widget _selectAddress({required BuildContext context}) {
    return Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 17, top: 22),
        padding: const EdgeInsets.only(left: 16, right: 16),
        height: 150,
        width: double.infinity,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialogAddress(
                          controller: _governorateController,
                          addressTitle: '??????????????',
                          list: _locationController.governorateList,
                          saveLocation:
                              _printOfficeController.updateGovernorate,
                        )).then((value) {
                  if (_printOfficeController.governorate.isNotEmpty) {
                    setState(() {
                      printOffice++;
                    });
                    _locationController.updateCityList(
                        _printOfficeController.governorate.value);
                  }
                });
              },
              child: TextFormFieldController(
                  isEnabled: false,
                  name: '?????????? ??????????????',
                  type: TextInputType.name,
                  controller: _governorateController),
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                if (_governorateController.text.isNotEmpty &&
                    _locationController.cityList.isNotEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialogAddress(
                            controller: _cityController,
                            addressTitle: '?????????? ????????????/??????????',
                            list: _locationController.cityList,
                            saveLocation: _printOfficeController.updateCity,
                          )).then((value) {
                    if (_printOfficeController.city.isNotEmpty) {
                      setState(() {
                        printOffice++;
                      });

                      // printOfficeController.getPrintOffices(
                      //     printOfficeController.governorate.value,
                      //     printOfficeController.city.value);
                    }
                  });
                } else {
                  Utils.snackBar(context: context, msg: '???????? ?????????????? ????????');
                }
              },
              child: TextFormFieldController(
                  isEnabled: false,
                  name: '?????????? ????????????/??????????',
                  type: TextInputType.name,
                  controller: _cityController),
            ),
          ],
        ));
  }

//delivery or not
  Widget _determineDelivery() {
    return Padding(
      padding: const EdgeInsets.only(top: 1, left: 12, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '?????????? ???????? ??????????????',
            style: Theme.of(context).textTheme.headline4,
          ),
          Row(
            children: [
              Text(
                '??????',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(
                width: 10,
              ),
              FlutterSwitch(
                width: 52.0,
                height: 28.0,
                valueFontSize: 0.0,
                toggleSize: 35.0,
                value: _switchVal,
                activeColor: MainColor.darkGreyColor,
                toggleColor: MainColor.yellowColor,
                inactiveToggleColor: Colors.white70,
                borderRadius: 30.0,
                padding: 1.5,
                showOnOff: true,
                onToggle: (val) {
                  setState(() {
                    _switchVal = val;
                  });
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                '????',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _determinePrintOffice() {
    return Padding(
      padding: const EdgeInsets.only(right: 12, left: 12),
      child: Column(children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10, top: 15),
          padding: const EdgeInsets.only(left: 16, right: 16),
          height: 45,
          width: double.infinity,
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
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            InkWell(
              onTap: () {
                setState(() {
                  indexSelected = 0;
                });
              },
              child: Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Text(
                        '???????????? ???????????? ??????',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.print_outlined,
                        color: MainColor.darkGreyColor,
                        size: 17,
                      ),
                    ],
                  ),
                  (indexSelected == 0)
                      ? _expandedSelectedPrintOffice()
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            Container(
              height: 35,
              color: MainColor.darkGreyColor,
              width: 1,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  indexSelected = 1;
                  Get.to(DrawMapPrintOffice(
                    latitude: _locationController
                        .cityList[_printOfficeController.cityIndex.value]
                        .latitude,
                    langitude: _locationController
                        .cityList[_printOfficeController.cityIndex.value]
                        .langitude,
                  ));
                });
              },
              child: Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Text(
                        '?????? ??????????????',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.map_outlined,
                        color: MainColor.darkGreyColor,
                        size: 17,
                      ),
                    ],
                  ),
                  (indexSelected == 1)
                      ? _expandedSelectedPrintOffice()
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ]),
        ),
      ]),
    );
  }

//draw line under selected option
  Widget _expandedSelectedPrintOffice() {
    return Expanded(
        child: Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        height: 4,
        width: MediaQuery.of(context).size.width / 4,
        color: MainColor.darkGreyColor,
      ),
    ));
  }

  Widget _drawPrintOffice() {
    return SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 275,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('serviceProvidersPrintOffices')
                    .doc(_printOfficeController.governorate.value)
                    .collection(_printOfficeController.city.value)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(
                        child: CircularProgressIndicator(
                          color: MainColor.darkGreyColor,
                        ),
                      );
                    default:
                      _locationController.clearMarkerLocaitonsList();
                      _printOfficeController.list.clear();
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                  child: CircularProgressIndicator(
                                      color: MainColor.darkGreyColor));
                            }
                            _locationController.updateMarkerLocations(
                                latitude: snapshot.data!.docs[index]
                                    ['latitude'],
                                longitude: snapshot.data!.docs[index]
                                    ['longitude']);
                            _printOfficeController.updateListOfPrintOffice(
                                printOffice: PrintOffice(
                                    id: snapshot.data!.docs[index].id,
                                    printOfficeName: snapshot.data!.docs[index]
                                        ['printOfficeName'],
                                    printOfficeUrl: snapshot.data!.docs[index]
                                        ['printOfficeUrl'],
                                    printOfficeAddress: snapshot.data!
                                        .docs[index]['printOfficeAddress'],
                                    printOfficeRating: snapshot
                                        .data!.docs[index]['rating']
                                        .toDouble(),
                                    city: snapshot.data!.docs[index]['city'],
                                    governorate: snapshot.data!.docs[index]
                                        ['governorate'],
                                    status: snapshot.data!.docs[index]
                                        ['status'],
                                    latitude: snapshot.data!.docs[index]
                                        ['latitude'],
                                    longitude: snapshot.data!.docs[index]
                                        ['longitude']));
                            return DrawPrintOffice(
                              printOfficeController: snapshot.data!.docs[index],
                             
                            );
                          });
                  }
                })));
  }
}
