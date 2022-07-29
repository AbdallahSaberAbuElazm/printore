import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/admin/add_print_officers.dart';
import 'package:printore/views/auth/login.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/user_shared_preferences.dart';
import 'package:provider/provider.dart';

class AdminNavigationDrawer extends StatefulWidget {
  const AdminNavigationDrawer({Key? key}) : super(key: key);

  @override
  State<AdminNavigationDrawer> createState() => _AdminNavigationDrawerState();
}

class _AdminNavigationDrawerState extends State<AdminNavigationDrawer> {
  // final ImagePicker _picker = ImagePicker();
  OptionProvider? option;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    option = Provider.of<OptionProvider>(context, listen: false);
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16)),
                image: DecorationImage(
                    image: AssetImage('assets/images/profileBackground.png'),
                    fit: BoxFit.cover)),
            accountEmail: Text('${UserSharedPreferences.getUseremail()} '),
            accountName: Text('${UserSharedPreferences.getUserName()} '),
            currentAccountPicture: CircleAvatar(
              backgroundColor: MainColor.yellowColor,
              backgroundImage: NetworkImage((UserSharedPreferences
                          .getUserAvatarUrl() !=
                      null)
                  ? UserSharedPreferences.getUserAvatarUrl()!
                  : 'https://firebasestorage.googleapis.com/v0/b/printore-2364c.appspot.com/o/vz5KFq5YWxRT7HqZkSw1gm2LAu02%2Fprofile%2Fcamera.png?alt=media&token=88a3a37c-f351-4278-bcff-aaf95b54b8f2'),
            ),
          ),
          _drawListTitle(
              context: context,
              func: () => Get.to(() => const AddPrintOfficers()),
              title: 'اضافة صاحب مكتبة',
              icon: Icons.person_add),
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
              title: 'تسجيل الخروج',
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

  // Widget _drawListTitleWithImage({
  //   required BuildContext context,
  //   required dynamic func,
  //   required String title,
  //   required String url,
  // }) {
  //   return ListTile(
  //     onTap: func,
  //     title: Text(
  //       title,
  //       style: Theme.of(context).textTheme.bodyText1,
  //     ),
  //     leading: SizedBox(
  //         width: 29,
  //         height: 30,
  //         child: Image.asset(
  //           url,
  //         )),
  //   );
  // }
}
