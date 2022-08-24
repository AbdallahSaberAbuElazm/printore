import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/user_layout/profile/new_address.dart';

class AddressCard extends StatelessWidget {
  final String userName;
  final String phone;
  final String location;
  AddressCard(
      {Key? key,
      required this.userName,
      required this.phone,
      required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _addressesInfo(context: context);
  }

  Widget _addressesInfo({required BuildContext context}) {
    return Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 17),
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 20,
          bottom: 16,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
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
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () => Get.to(() => NewAddress(
                      userData: {
                        'recieverName': userName,
                        'recieverPhoneNo': phone,
                        'address': location
                      },
                    )),
                child: Icon(
                  Icons.mode_edit_outline_sharp,
                  size: 26,
                  color: Colors.lightBlue,
                ),
              ),
            ),
            _drawUserInfo(
                icon: Icons.person_outline_outlined,
                title: userName,
                context: context),
            _drawUserInfo(
                icon: Icons.phone_android_outlined,
                title: phone,
                context: context),
            _drawUserInfo(
                icon: Icons.location_on_outlined,
                title: location,
                context: context)
          ],
        ));
  }

  Widget _drawUserInfo(
      {required IconData icon,
      required String title,
      required BuildContext context}) {
    return Row(
      children: [
        Icon(
          icon,
          color: MainColor.darkGreyColor,
          size: 22,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}
