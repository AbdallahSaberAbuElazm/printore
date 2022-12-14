import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/auth/login.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/user_shared_preferences.dart';
import 'package:printore/views/shared/widgets/upload_image_profile.dart';
import 'package:printore/views/user_layout/discount/discount.dart';
import 'package:printore/views/user_layout/file_upload/convert_to_pdf.dart';
import 'package:printore/views/user_layout/frequently_question/frequently_asked_question_screen.dart';
import 'package:printore/views/user_layout/home/home.dart';
import 'package:printore/views/user_layout/home/home_page.dart';
import 'package:printore/views/user_layout/home/profile_screen.dart';
import 'package:printore/views/user_layout/home/upload_page.dart';
import 'package:printore/views/user_layout/offers/offers.dart';
import 'package:printore/views/user_layout/profile/my_addresses.dart';
import 'package:printore/views/user_layout/qr_code/qr_code_user.dart';
import 'package:printore/views/user_layout/review/review_screen.dart';
import 'package:printore/views/user_layout/who_are_we/contact_us.dart';
import 'package:printore/views/user_layout/who_are_we/who_are_we.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserNavigationDrawer extends StatefulWidget {
  const UserNavigationDrawer({Key? key}) : super(key: key);

  @override
  State<UserNavigationDrawer> createState() => _UserNavigationDrawerState();
}

class _UserNavigationDrawerState extends State<UserNavigationDrawer> {
  OptionProvider? option;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    option = Provider.of<OptionProvider>(context, listen: false);
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.only(bottom: 20),
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16)),
                image: DecorationImage(
                    image: AssetImage('assets/images/profileBackground.png'),
                    fit: BoxFit.cover)),
            accountEmail:
                Text('${UserSharedPreferences.getUseremail().toString()} '),
            accountName:
                Text('${UserSharedPreferences.getUserName().toString()} '),
            currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: MainColor.yellowColor,
                  backgroundImage: (UserSharedPreferences.getUserAvatarUrl() !=
                          null)
                      ? NetworkImage(
                          UserSharedPreferences.getUserAvatarUrl().toString())
                      : const NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/printore-2364c.appspot.com/o/app_images%2FappIcon.png?alt=media&token=3c536f0b-4cce-440f-823f-d86541e164d5'),
                ),
                onTap: () {
                  UploadImageProfile.uploadImageProfile(context: context)
                      .then((value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        UserSharedPreferences.setUserAvatar(
                            url: value['url'],
                            photoName: basename(value['avatarName']));
                      });
                    }
                  });
                }),
          ),
          _drawListTitleWithImage(
              context: context,
              func: () async {
                const url = 'https://www.ilovepdf.com/merge_pdf';
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              title: '?????? ???????????? ???? ?????? ????????',
              url: 'assets/images/mergeFiles.png'),
          _drawListTitleWithImage(
              context: context,
              func: () => Get.to(() => ConvertToPdf()),
              title: '?????????? ???????? ?????? ???????? PDF',
              url: 'assets/images/convertToPDF.png'),
          _drawListTitle(
              context: context,
              func: () {
                option!.advancedDrawerController.value =
                    AdvancedDrawerValue.hidden();
                Navigator.pop(context);
                Get.to(() => Home(recentPage: HomePage(), selectedIndex: 0));
              },
              title: '????????????????',
              icon: Icons.print_outlined),
          _drawListTitle(
              context: context,
              func: () {
                option!.advancedDrawerController.value =
                    AdvancedDrawerValue.hidden();
                Navigator.pop(context);
                Get.to(() => Home(recentPage: UploadPage(), selectedIndex: 2));
              },
              title: '????????????',
              icon: Icons.file_upload_outlined),
          _drawListTitle(
              context: context,
              func: () {
                option!.advancedDrawerController.value =
                    AdvancedDrawerValue.hidden();
                Navigator.pop(context);
                Get.to(
                    () => Home(recentPage: ProfileScreen(), selectedIndex: 4));
              },
              title: '?????????? ????????????',
              icon: Icons.person_outline_outlined),
          _drawListTitle(
              context: context,
              func: () => Get.to(() => QRCodeUser(
                    fromDrawer: true,
                  )),
              title: '?????? ?????? ??????????',
              icon: Icons.qr_code_2_outlined),
          _drawListTitle(
              context: context,
              func: () => Get.to(() => const Offers()),
              title: '????????????',
              icon: Icons.local_offer_outlined),
          _drawListTitle(
              context: context,
              func: () => Get.to(() => MyAddress()),
              title: '??????????????',
              icon: Icons.my_location_outlined),
          _drawListTitleWithImage(
              context: context,
              func: () => Get.to(() => Discount()),
              title: '?????????? ??????????',
              url: 'assets/images/voucher.png'),
          _drawListTitle(
              context: context,
              func: () => Get.off(() => const FrequentlyAskedQuestionScreen()),
              title: '?????????????? ??????????????',
              icon: Icons.question_mark_rounded),
          _drawListTitle(
              context: context,
              func: () => Get.to(() => ReviewScreen()),
              title: '?????????? ????????????',
              icon: Icons.reviews),
          _drawListTitle(
              context: context,
              func: () => Get.to(() => WhoAreWe()),
              title: '???? ??????',
              icon: Icons.people),
          _drawListTitle(
              context: context,
              func: () => Get.to(() => ContactUs()),
              title: '?????????????? ????????',
              icon: Icons.contact_phone_outlined),
          _drawListTitle(
              context: context,
              func: () async {
                await FirebaseAuth.instance.signOut().then((value) {
                  UserSharedPreferences.removeDataForLogout();
                  option!.advancedDrawerController.value =
                      AdvancedDrawerValue.hidden();
                  Get.off(() => const Login());
                });
              },
              title: '?????????? ????????????',
              icon: Icons.logout_outlined),
        ],
      ),
    );
  }

  Widget _drawListTitle({
    required BuildContext context,
    required dynamic func,
    required String title,
    required IconData icon,
  }) {
    return ListTile(
      onTap: func,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      leading: Icon(
        icon,
        color: MainColor.darkGreyColor,
        size: 28,
      ),
    );
  }

  Widget _drawListTitleWithImage({
    required BuildContext context,
    required dynamic func,
    required String title,
    required String url,
  }) {
    return ListTile(
      onTap: func,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      leading: SizedBox(
          width: 29,
          height: 30,
          child: Image.asset(
            url,
          )),
    );
  }
}
