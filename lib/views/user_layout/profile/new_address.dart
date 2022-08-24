import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/controller/address_controller.dart';
import 'package:printore/controller/print_officce_controller.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/auth/widgets/text_form_field.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/user_layout/profile/determine_address.dart';
import 'package:printore/views/user_layout/profile/my_addresses.dart';

class NewAddress extends StatefulWidget {
  final Map<String, dynamic> userData;
  NewAddress({Key? key, required this.userData}) : super(key: key);
  @override
  State<NewAddress> createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  final _rNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _governorateController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressNameController = TextEditingController();
  final PrintOfficeController _printOfficeController = Get.find();
  // final _streetNameController = TextEditingController();
  // final _buildingNoController = TextEditingController();
  // final _apartmentNoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final AddressController _addressController = Get.find();
  @override
  void initState() {
    _rNameController.text = widget.userData['recieverName'] ?? '';
    _phoneController.text = widget.userData['recieverPhoneNo'] ?? '';
    _addressNameController.text = widget.userData['address'] ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _rNameController.dispose();
    _governorateController.dispose();
    _cityController.dispose();
    _addressNameController.dispose();
    // _streetNameController.dispose();
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
            title: Styles.appBarText('أضف عنوانك', context),
            centerTitle: true,
            leading: const SizedBox.shrink(),
            actions: [
              Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    onPressed: () => Get.off(() => MyAddress()),
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 26,
                    ),
                  )),
            ],
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(right: 30, left: 30),
              child: ListView(children: [
                const SizedBox(
                  height: 40,
                ),
                TextFormFieldController(
                    isEnabled: true,
                    name: 'إسم مستقبل الخدمة',
                    type: TextInputType.name,
                    controller: _rNameController),
                const SizedBox(
                  height: 18,
                ),
                TextFormFieldController(
                    isEnabled: true,
                    name: "رقم الجوال",
                    type: TextInputType.phone,
                    controller: _phoneController),

                const SizedBox(height: 18),
                // TextFormFieldController(
                //     isEnabled: true,
                //     name: 'إسم الشارع',
                //     type: TextInputType.streetAddress,
                //     controller: _streetNameController),
                TextFormFieldController(
                    isEnabled: true,
                    name: 'العنوان',
                    type: TextInputType.streetAddress,
                    controller: _addressNameController),
                // const SizedBox(height: 18),
                // TextFormFieldController(
                //     isEnabled: true,
                //     name: 'إسم العقار',
                //     type: TextInputType.streetAddress,
                //     controller: _buildingNoController),
                // const SizedBox(height: 18),
                // TextFormFieldController(
                //     isEnabled: true,
                //     name: 'إسم الشقة',
                //     type: TextInputType.streetAddress,
                //     controller: _apartmentNoController),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                        onPressed: () {
                          _addressController.addAddressDuringOrder(
                              receiverName: _rNameController.text,
                              receiverPhoneNo: _phoneController.text,
                              receiverGovernorate:
                                  _printOfficeController.governorate.value,
                              receiverCity: _printOfficeController.city.value,
                              address: _addressNameController.text);
                          _rNameController.text = '';
                          _phoneController.text = '';
                          _addressNameController.text = '';
                          Get.off(() => MyAddress());
                        },
                        child: Text(
                          (widget.userData.isEmpty)
                              ? 'أضف عنوان جدبد'
                              : 'تعديل',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )),
                  ),
                ),
              ]),
            ),
          ),
        ));
  }
}
