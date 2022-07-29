import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/widgets/user_navigation_drawer.dart';
import 'package:printore/views/user_layout/home/home_page.dart';
import 'package:printore/views/user_layout/home/upload_page.dart';
import 'package:printore/views/user_layout/home/wallet.dart';
import 'package:printore/views/user_layout/home/wish_list.dart';
import 'package:printore/views/user_layout/home/profile_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  Widget recentPage;
  int selectedIndex;
  Home({Key? key, required this.recentPage, required this.selectedIndex})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  OptionProvider? option;
  List<Widget> pages = [
    const HomePage(),
    const WishList(),
    const UploadPage(),
    const Wallet(),
    const ProfileScreen(),
  ];
  void updateTabSelection(int index) {
    setState(() {
      widget.selectedIndex = index;
      widget.recentPage = pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;
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
            disabledGestures: false,
            childDecoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            drawer: const UserNavigationDrawer(),
            child: Scaffold(
              body: widget.recentPage,
              floatingActionButtonLocation: FloatingActionButtonLocation
                  .centerDocked, //specify the location of the FAB
              floatingActionButton: Visibility(
                visible: !showFab,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      updateTabSelection(2);
                    });
                  },
                  tooltip: "تحميل ملف",
                  child: const Center(
                    child: Icon(
                      Icons.file_upload,
                      size: 34,
                    ),
                  ),
                  elevation: 4.0,
                  backgroundColor: widget.selectedIndex == 2
                      ? MainColor.yellowColor
                      : MainColor.darkGreyColor,
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6)),
                  ),
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
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          index: 1,
                          name: 'المفضلات'),
                      //to leave space in between the bottom app bar items and below the FAB
                      const SizedBox(
                        width: 50.0,
                      ),
                      _drawIcon(
                          icon: widget.selectedIndex == 3
                              ? Icons.account_balance_wallet
                              : Icons.account_balance_wallet_outlined,
                          index: 3,
                          name: 'محفظتي'),
                      _drawIcon(
                          icon: widget.selectedIndex == 4
                              ? Icons.person
                              : Icons.person_outline,
                          index: 4,
                          name: 'حسابي'),
                    ],
                  ),
                ),
                //to add a space between the FAB and BottomAppBar
                shape: const CircularNotchedRectangle(),
                //color of the BottomAppBar
                color: Colors.white,
              ),
            )));
  }

  // void _handleMenuButtonPressed() {
  //   // NOTICE: Manage Advanced Drawer state through the Controller.
  //   // _advancedDrawerController.value = AdvancedDrawerValue.visible();
  //   option!.advancedDrawerController.showDrawer();
  // }

  //icon for bottom navigation bar
  Widget _drawIcon(
      {required IconData icon, required int index, required String name}) {
    return SizedBox(
      width: 76,
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
