import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/widgets/button_center_button.dart';
import 'package:printore/views/user_layout/order/order_summary.dart';
import 'package:printore/views/user_layout/profile/new_address.dart';
import 'package:printore/views/user_layout/select_library/locating.dart';

class DetermineAddress extends StatefulWidget {
  const DetermineAddress({Key? key}) : super(key: key);

  @override
  State<DetermineAddress> createState() => _DetermineAddressState();
}

class _DetermineAddressState extends State<DetermineAddress> {
  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: MainColor.darkGreyColor,
              title: Styles.appBarText('حدد عنوانك الآن', context),
              centerTitle: true,
              leadingWidth: 100,
              leading: TextButton(
                onPressed: () => Get.off(() => const NewAddress()),
                child: Text(
                  'أضف عنوان جديد',
                  style: TextStyle(
                      color: MainColor.yellowColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500),
                ),
              ),
              actions: [
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      onPressed: () => Get.to(() => const Locating()),
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 26,
                      ),
                    )),
              ],
            ),
            bottomSheet: BottomCenterButton(
                buttonTitle: 'إستمرار',
                onPressed: () => Get.to(() => OrderSummary()),
                // onPressed: null,
                actionRelated: true),
            body: Stack(
              children: [
                _selectAddress(context: context),
              ],
            )));
  }

  Widget _selectAddress({required BuildContext context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Column(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 6,
              child: Image.asset(
                'assets/images/no-address-found.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Text(
                'لم تضف عناوين لك حتي الآن !!',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            SizedBox(
              height: 55,
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: MainColor.yellowColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                onPressed: () => Get.off(() => const NewAddress()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'أضف عنوان جدبد',
                      style: TextStyle(
                          color: MainColor.darkGreyColor, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.add,
                      color: MainColor.darkGreyColor,
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
