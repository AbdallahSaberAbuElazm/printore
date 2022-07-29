import 'package:flutter/material.dart';
import 'package:printore/views/shared/styles/colors.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.1,
        child: ListView.builder(
            padding: const EdgeInsets.only(top: 20, bottom: 66),
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index) {
              return _addressesInfo(context: context);
            }),
      ),
    );
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
            const Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: null,
                child: Icon(
                  Icons.mode_edit_outline_sharp,
                  size: 23,
                  color: Colors.lightBlue,
                ),
              ),
            ),
            _drawUserInfo(
                icon: Icons.person_outline_outlined,
                title: 'أحمد عاطف',
                context: context),
            _drawUserInfo(
                icon: Icons.phone_android_outlined,
                title: '01022150743',
                context: context),
            _drawUserInfo(
                icon: Icons.location_on_outlined,
                title: '9 شارع الجيش - زفتي - الغربية',
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
