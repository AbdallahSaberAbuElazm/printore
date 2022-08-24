import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/util/util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int prints = 0;
  OptionProvider? option;

  Future<bool> _onWillPop() async {
    return (await Utils.showDialogOnWillPop(context: context)) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    option = Provider.of<OptionProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.notifications_active,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
                leading: IconButton(
                  onPressed: option!.handleMenuButtonPressed,
                  icon: ValueListenableBuilder<AdvancedDrawerValue>(
                    valueListenable: option!.advancedDrawerController,
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
                centerTitle: true,
                title: Styles.appBarText('الصفحة الرئيسية', context),
              ),
              body: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(children: [
                  Stack(children: [
                    Image.asset(
                      'assets/images/Group 2361.png',
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                      fit: BoxFit.fill,
                      //color: const Color(0xffe5e5e5),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height / 10.9,
                      left: 30,
                      right: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          drawPaperDetail(
                              context: context,
                              detailName: 'الملفات',
                              detailNo: 0),
                          drawPaperDetail(
                              context: context,
                              detailName: 'الطلبات',
                              detailNo: 0)
                        ],
                      ),
                    ),
                  ]),
                  _drawListPrint(context: context),
                ]),
              ))),
    );
  }

  Widget drawPaperDetail(
      {required BuildContext context,
      required String detailName,
      required int detailNo}) {
    return Stack(children: [
      SizedBox(
        width: 167,
        height: 160,
        child: Image.asset('assets/images/Group 2383.png'),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 55, top: 24),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'عدد',
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                detailName,
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                '$detailNo',
                style: Theme.of(context).textTheme.headline5,
              ),
            ]),
      ),
    ]);
  }

  Widget _drawListPrint({required BuildContext context}) {
    return (prints > 0)
        ? _drawContainerOrders(context: context)
        : Padding(
            padding: const EdgeInsets.only(top: 140),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 6,
                  child: Image.asset(
                    'assets/images/no-files-found-removebg-preview.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'لا يوجد طلب حتي الأن',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          );
  }

// If there are orders
  Widget _drawContainerOrders({required BuildContext context}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 45, left: 12, right: 12),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مطبوعاتي اّخر $prints  طلبات',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ]),
        ),
        Container(
            padding: const EdgeInsets.only(bottom: 90),
            height: 500,
            child: ListView.builder(
                itemCount: prints,
                itemBuilder: (context, index) {
                  return Transform.translate(
                    offset: const Offset(0, -20),
                    child: Stack(children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 39),
                        height: 130,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 8,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _drawListTile(
                                    icon: Icons.print_outlined,
                                    title: 'مكتبة حسونه'),
                                Padding(
                                    padding: const EdgeInsets.only(left: 19),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _drawListTile(
                                            icon: Icons.date_range_outlined,
                                            title: Styles.formattedDate),
                                        Text(
                                          '1111111',
                                          style: TextStyle(
                                              color: MainColor.darkGreyColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(left: 19),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _drawListTile(
                                          icon: Icons.file_upload,
                                          title: 'ملفات'),
                                      Text(
                                        'رقم الطلب',
                                        style: Styles.detailTheme,
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      Transform.translate(
                          offset: const Offset(0, -39),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Row(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 7, right: 24),
                                  padding: const EdgeInsets.only(
                                      left: 11, right: 11),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6)),
                                      color: MainColor.yellowColor),
                                  child: Text(
                                    'تم الإستلام',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 7),
                                  padding: const EdgeInsets.only(
                                      left: 11, right: 11),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6)),
                                      color: MainColor.yellowColor),
                                  child: Text(
                                    'الإستلام من الفرع',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Theme.of(context).backgroundColor,
                                          width: 4),
                                      color: const Color(0xffffffff),
                                      shape: BoxShape.circle),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('1.50',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3),
                                        Text('جنيه',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                      ]),
                                ),
                              ],
                            ),
                          )),
                    ]),
                  );
                }))
      ],
    );
  }

  Widget _drawListTile({required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.only(right: 19),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.5,
            color: MainColor.darkGreyColor,
          ),
          Text(
            '  $title',
            style: Styles.detailTheme,
          ),
        ],
      ),
    );
  }
}
