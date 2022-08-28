import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:printore/controller/location_controller.dart';
import 'package:printore/controller/print_officce_controller.dart';
import 'package:printore/model/service_providers/print_office.dart';
import 'package:printore/views/auth/widgets/text_form_field.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/util/util.dart';
import 'package:printore/views/shared/widgets/admin_navigation_drawer.dart';
import 'package:printore/views/shared/widgets/alert_dialog_address.dart';
import 'package:printore/views/shared/widgets/text_field_number.dart';

class AddPrintOfficers extends StatefulWidget {
  const AddPrintOfficers({Key? key}) : super(key: key);

  @override
  State<AddPrintOfficers> createState() => _AddPrintOfficersState();
}

class _AddPrintOfficersState extends State<AddPrintOfficers> {
  final _advancedDrawerController = AdvancedDrawerController();
  final PrintOfficeController _printOfficeController =
      Get.find<PrintOfficeController>();
  final ImagePicker _picker = ImagePicker();
  final _emailController = TextEditingController();
  final _printOfficeNameController = TextEditingController();
  final _printOfficeAddressController = TextEditingController();
  final _governorateController = TextEditingController();
  final _cityController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _priceSizeController = TextEditingController();
  final _priceWrappingController = TextEditingController();
  final _workingHoursController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final LocationController _locationController = Get.find<LocationController>();
  bool _switchVal = false;
  Map<String, dynamic> sizeMap = {};
  Map<String, dynamic> wrappingMap = {};
  Map<String, dynamic> workingHoursMap = {};

  String dropdownSizeValue = 'A4';
  String dropdownWorkingHoursValue = 'السبت';
  String dropdownWrappingValue = 'كيس شفاف';

  @override
  void dispose() {
    _emailController.dispose();
    _printOfficeAddressController.dispose();
    _governorateController.dispose();
    _cityController.dispose();
    _printOfficeNameController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _workingHoursController.dispose();
    _priceSizeController.dispose();
    _priceWrappingController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: AdvancedDrawer(
          backdropColor: const Color.fromARGB(255, 236, 239, 241),
          controller: _advancedDrawerController,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 80),
          animateChildDecoration: true,
          rtlOpening: true,
          disabledGestures: false,
          childDecoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          drawer: const AdminNavigationDrawer(),
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: MainColor.darkGreyColor,
              title: Styles.appBarText('اضف صاحب مكتبة', context),
              centerTitle: true,
              leading: IconButton(
                onPressed: _handleMenuButtonPressed,
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: _advancedDrawerController,
                  builder: (_, value, __) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        value.visible ? Icons.clear : Icons.menu,
                        key: ValueKey<bool>(value.visible),
                      ),
                    );
                  },
                ),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _searchOnPrintOffice(context),
                _determinePrintOfficer(context),
                TextFormFieldController(
                    isEnabled: true,
                    name: 'الاسم',
                    type: TextInputType.name,
                    controller: _printOfficeNameController),
                const SizedBox(
                  height: 18,
                ),
                TextFormFieldController(
                    isEnabled: true,
                    name: 'العنوان',
                    type: TextInputType.name,
                    controller: _printOfficeAddressController),
                const SizedBox(height: 18),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialogAddress(
                              controller: _governorateController,
                              addressTitle: 'محافظتك',
                              list: _locationController.governorateList,
                              saveLocation:
                                  _printOfficeController.updateGovernorate,
                            )).then((value) {
                      _locationController.updateCityList(
                          _printOfficeController.governorate.value);
                    });
                  },
                  child: TextFormFieldController(
                      isEnabled: false,
                      name: "المحافظة",
                      type: TextInputType.name,
                      controller: _governorateController),
                ),
                const SizedBox(height: 18),
                InkWell(
                  onTap: () {
                    if (_governorateController.text.isNotEmpty) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialogAddress(
                                controller: _cityController,
                                addressTitle: 'إختار مدينتك/قريتك',
                                list: _locationController.cityList,
                                saveLocation: _printOfficeController.updateCity,
                              ));
                    }
                  },
                  child: TextFormFieldController(
                      isEnabled: false,
                      name: "المدينة",
                      type: TextInputType.name,
                      controller: _cityController),
                ),
                TextFormFieldController(
                    isEnabled: true,
                    name: 'خط العرض (latitude)',
                    type: TextInputType.name,
                    controller: _latitudeController),
                TextFormFieldController(
                    isEnabled: true,
                    name: 'خط الطول (longitude)',
                    type: TextInputType.name,
                    controller: _longitudeController),
                _addPrintOffice(context),
                _uploadLogo(context),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'خيارات الطباعة',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dropDownMenuSize(context: context),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4.2,
                      child: TextFieldNumber(
                        controller: _fromController,
                        hintName: 'من',
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4.2,
                      child: TextFieldNumber(
                        controller: _toController,
                        hintName: 'الي',
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4.2,
                      child: TextFieldNumber(
                        controller: _priceSizeController,
                        hintName: 'السعر',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 17,
                ),
                _buttonAddSizeOption(
                    paperSize: dropdownSizeValue,
                    fromPage: _fromController.text.trim(),
                    toPage: _toController.text.trim(),
                    price: _priceSizeController.text,
                    context: context),
                const SizedBox(
                  height: 17,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dropDownMenuWrapping(context: context),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.8,
                      child: TextFieldNumber(
                        hintName: 'السعر',
                        controller: _priceWrappingController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 17,
                ),
                _buttonAddWrappingOption(
                    wrapping: dropdownWrappingValue,
                    price: _priceWrappingController.text,
                    context: context),
                const SizedBox(
                  height: 17,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dropDownMenuWorkingHours(context: context),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.7,
                      child: TextFormFieldController(
                          isEnabled: true,
                          name: 'ساعات العمل',
                          type: TextInputType.name,
                          controller: _workingHoursController),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 17,
                ),
                _buttonAddWorkingHours(
                    day: dropdownWorkingHoursValue,
                    workingHours: _workingHoursController.text,
                    context: context),
                const SizedBox(
                  height: 17,
                ),
              ],
            ),
          ),
        ));
  }

//PrintOfficer or not
  Widget _determinePrintOfficer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'هل صاحب مكتب طباعة',
            style: Theme.of(context).textTheme.headline4,
          ),
          Row(
            children: [
              Text(
                'نعم',
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
                    _printOfficeController.makeUserAsPrintOfficer(
                        printOfficeId: _printOfficeController
                            .searchOnPrintOffice[0].userId
                            .toString(),
                        value: val);
                  });
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'لا',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          )
        ],
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  Widget _searchOnPrintOffice(BuildContext context) {
    return Column(
      children: [
        Container(
          margin:
              const EdgeInsets.only(left: 12, right: 12, bottom: 20, top: 22),
          padding: const EdgeInsets.only(left: 16, right: 16),
          height: 135,
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
            children: [
              TextFormFieldController(
                  isEnabled: true,
                  name: 'ابحث باستخدام الايميل',
                  type: TextInputType.emailAddress,
                  controller: _emailController),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    _printOfficeController.searchOnPrintOfficeUsingEmail(
                        email: _emailController.text.trim());
                    if (_printOfficeController.searchOnPrintOffice.isNotEmpty) {
                      setState(() {
                        _switchVal = _printOfficeController
                            .searchOnPrintOffice[0].printingOfficer!;
                      });
                    }
                  },
                  child: Container(
                    width: 90,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 8,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ]),
                    child: Center(
                      child: Text(
                        'ابحث',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        (_printOfficeController.searchOnPrintOffice.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'اسم المستخدم : ${_printOfficeController.searchOnPrintOffice[0].firstName.toString() + ' ' + _printOfficeController.searchOnPrintOffice[0].lastName.toString()}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _uploadLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 12,
        top: 20,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.8,
        height: 47,
        child: ElevatedButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    const EdgeInsets.only(right: 15, left: 10)),
                backgroundColor:
                    MaterialStateProperty.all(MainColor.yellowColor),
                alignment: Alignment.center),
            onPressed: () async {
              final XFile? image =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                final file = File(image.path);
                try {
                  var taskSnapshot = FirebaseStorage.instance
                      .ref(
                          '${_printOfficeController.searchOnPrintOffice[0].userId}/profile/${basename(image.path)}')
                      .putFile(file);
                  final url = await (await taskSnapshot).ref.getDownloadURL();
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(_printOfficeController.searchOnPrintOffice[0].userId
                          .toString()
                          .trimLeft()
                          .trimRight())
                      .update({'avatarUrl': url});
                  FirebaseFirestore.instance
                      .collection('serviceProvidersPrintOffices')
                      .doc(_governorateController.text)
                      .collection(_cityController.text)
                      .doc(_printOfficeController.searchOnPrintOffice[0].userId
                          .toString()
                          .trimLeft()
                          .trimRight())
                      .update({'printOfficeUrl': url});
                } on FirebaseException catch (e) {
                  return Utils.snackBar(context: context, msg: e.message);
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'إرفع لوجو',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.image,
                  size: 27,
                  color: Colors.white,
                ),
              ],
            )),
      ),
    );
  }

  Widget _addPrintOffice(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 12, top: 15),
        child: SizedBox(
            width: MediaQuery.of(context).size.width / 2.8,
            height: 47,
            child: ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.only(right: 15, left: 10)),
                  backgroundColor:
                      MaterialStateProperty.all(MainColor.darkGreyColor),
                  alignment: Alignment.center),
              onPressed: () {
                _printOfficeController.addPrintOfficer(
                    governorate: _printOfficeController.governorate.value
                        .toString()
                        .trimLeft()
                        .trimRight(),
                    city: _printOfficeController.city.value
                        .toString()
                        .trimLeft()
                        .trimRight(),
                    printOfficerId: _printOfficeController
                        .searchOnPrintOffice[0].userId
                        .toString(),
                    printOffice: PrintOffice(
                        id: _printOfficeController
                            .searchOnPrintOffice[0].firstName
                            .toString(),
                        printOfficeName: _printOfficeNameController.text,
                        printOfficeUrl: '',
                        printOfficeAddress: _printOfficeAddressController.text,
                        printOfficeRating: 0,
                        governorate: _printOfficeController.governorate.value
                            .toString()
                            .trimLeft()
                            .trimRight(),
                        city: _printOfficeController.city.value
                            .toString()
                            .trimLeft()
                            .trimRight(),
                        status: false,
                        latitude: double.parse(_latitudeController.text),
                        longitude: double.parse(_longitudeController.text)));
              },
              child: const Center(
                child: Text(
                  'اضف مكتبة الطباعة',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            )));
  }

  Widget _dropDownMenuSize({required BuildContext context}) {
    return SizedBox(
      width: 50,
      child: DropdownButton<String>(
        value: dropdownSizeValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 9,
        style: TextStyle(color: MainColor.darkGreyColor),
        underline: Container(
          height: 2,
          color: MainColor.darkGreyColor,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownSizeValue = newValue!;
          });
        },
        items: <String>['A1', 'A2', 'A3', 'A4', 'A5', 'A6']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: Theme.of(context).textTheme.headline3,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _dropDownMenuWrapping({required BuildContext context}) {
    return SizedBox(
      width: 150,
      child: DropdownButton<String>(
        value: dropdownWrappingValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 9,
        style: TextStyle(color: MainColor.darkGreyColor),
        underline: Container(
          height: 2,
          color: MainColor.darkGreyColor,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownWrappingValue = newValue!;
          });
        },
        items: <String>[
          'كيس شفاف',
          'تدبيس ركن',
          'تدبيس جانبي',
          'سلك',
          'كعب حراري',
          'كعب مسمار',
          'بلاستيك حلزوني',
          'تخييط',
          'ملف خرمين',
          'ملف 3 أخرام'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _dropDownMenuWorkingHours({required BuildContext context}) {
    return SizedBox(
      width: 90,
      child: DropdownButton<String>(
        value: dropdownWorkingHoursValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 9,
        style: TextStyle(color: MainColor.darkGreyColor),
        underline: Container(
          height: 2,
          color: MainColor.darkGreyColor,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownWorkingHoursValue = newValue!;
          });
        },
        items: <String>[
          'السبت',
          'الأحد',
          'الاثنين',
          'الثلاثاء',
          'الأربعاء',
          'الخميس',
          'الجمعة'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buttonAddSizeOption(
      {required String paperSize,
      required String fromPage,
      required String toPage,
      required String price,
      required BuildContext context}) {
    return InkWell(
      onTap: () {
        sizeMap.addAll({
          'paperSize': paperSize,
          'fromPage': fromPage,
          'toPage': toPage,
          'price': price
        });
        _fromController.text = '';
        _toController.text = '';
        _priceSizeController.text = '';

        _printOfficeController.uploadSizeOption(
            governorate: _printOfficeController.governorate.value
                .toString()
                .trimLeft()
                .trimRight(),
            city: _printOfficeController.city.value
                .toString()
                .trimLeft()
                .trimRight(),
            map: sizeMap,
            printOfficerId:
                _printOfficeController.searchOnPrintOffice[0].userId.toString(),
            paperSize: paperSize);
      },
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3,
            height: 47,
            decoration: BoxDecoration(
                color: MainColor.darkGreyColor,
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
              child: Text(
                'اضف',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonAddWrappingOption(
      {required String wrapping,
      required String price,
      required BuildContext context}) {
    return InkWell(
      onTap: () {
        wrappingMap.addAll({'wrapping': wrapping, 'price': price});
        _priceWrappingController.text = '';

        _printOfficeController.uploadWrappingOption(
            wrapping: wrapping,
            governorate: _printOfficeController.governorate.value
                .toString()
                .trimLeft()
                .trimRight(),
            city: _printOfficeController.city.value
                .toString()
                .trimLeft()
                .trimRight(),
            map: wrappingMap,
            printOfficerId: _printOfficeController.searchOnPrintOffice[0].userId
                .toString());
      },
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3,
            height: 47,
            decoration: BoxDecoration(
                color: MainColor.darkGreyColor,
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
              child: Text(
                'اضف',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonAddWorkingHours(
      {required String day,
      required String workingHours,
      required BuildContext context}) {
    return InkWell(
      onTap: () {
        workingHoursMap.addAll({'day': day, 'workingHours': workingHours});

        _workingHoursController.text = '';

        _printOfficeController.uploadWorkingHours(
            workingHours: workingHours,
            governorate: _printOfficeController.governorate.value
                .toString()
                .trimLeft()
                .trimRight(),
            city: _printOfficeController.city.value
                .toString()
                .trimLeft()
                .trimRight(),
            map: workingHoursMap,
            printOfficerId: _printOfficeController.searchOnPrintOffice[0].userId
                .toString());
      },
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3,
            height: 47,
            decoration: BoxDecoration(
                color: MainColor.darkGreyColor,
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
              child: Text(
                'اضف',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
