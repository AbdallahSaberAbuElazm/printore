import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:printore/controller/freq_asked_question__controller.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/advanced_drawer.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/widgets/user_navigation_drawer.dart';
import 'package:printore/views/user_layout/home/home.dart';
import 'package:printore/views/user_layout/home/home_page.dart';
import 'package:provider/provider.dart';

class FrequentlyAskedQuestionScreen extends StatefulWidget {
  const FrequentlyAskedQuestionScreen({Key? key}) : super(key: key);

  @override
  State<FrequentlyAskedQuestionScreen> createState() =>
      _FrequentlyAskedQuestionScreenState();
}

class _FrequentlyAskedQuestionScreenState
    extends State<FrequentlyAskedQuestionScreen> {
  late List filteredLocation;
  late List list;
  final _searchController = TextEditingController();
  OptionProvider? option;

  @override
  void initState() {
    list =
        Get.find<FrequentlyAskedQuestionController>().frequentlyAskedQuestions;
    setState(() {
      filteredLocation = list;
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //filter location
  void _filterLocation(value) {
    setState(() {
      filteredLocation = list
          .where((question) => question.questionName.contains(value))
          .toList();
    });
  }

  Future<bool> _onWillPop() async {
    return (await Get.off(
          () => Home(
            recentPage: const HomePage(),
            selectedIndex: 0,
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    option = Provider.of<OptionProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: AdvancedDrawer(
            backdropColor: const Color.fromARGB(255, 236, 239, 241),
            controller: AdvancedDrawerClass.advancedDrawerController,
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
                backgroundColor: Theme.of(context).backgroundColor,
                appBar: AppBar(
                  backgroundColor: MainColor.darkGreyColor,
                  title: Styles.appBarText('الاسئلة الشائعة', context),
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: AdvancedDrawerClass.handleMenuButtonPressed,
                    icon: ValueListenableBuilder<AdvancedDrawerValue>(
                      valueListenable:
                          AdvancedDrawerClass.advancedDrawerController,
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
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25, bottom: 9),
                        child: Container(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          width: double.infinity,
                          height: 55,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              _filterLocation(value);
                            },
                            style: TextStyle(
                              color: MainColor.darkGreyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: MainColor.darkGreyColor,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6)),
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: MainColor.darkGreyColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6)),
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: MainColor.darkGreyColor)),
                              fillColor: MainColor.darkGreyColor,
                              focusColor: MainColor.darkGreyColor,
                              hoverColor: MainColor.darkGreyColor,
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        color: MainColor.darkGreyColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          filteredLocation = list;
                                          _searchController.text = '';
                                        });
                                      },
                                    )
                                  : null,
                              prefixIcon: Icon(
                                Icons.search,
                                color: MainColor.darkGreyColor,
                              ),
                              hintText: ' إبحث هنا ',
                              hintStyle: TextStyle(
                                  color: MainColor.darkGreyColor, fontSize: 11),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 1.4,
                          child: ListView.builder(
                              itemCount: filteredLocation.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                      left: 12, right: 12, bottom: 6, top: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    color: Colors.white70.withOpacity(0.5),
                                  ),
                                  child: ExpansionTile(
                                    iconColor: MainColor.darkGreyColor,
                                    title: Text(
                                        filteredLocation[index].questionName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4),
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                          left: 12,
                                          right: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).backgroundColor,
                                        ),
                                        child: Text(
                                            filteredLocation[index]
                                                .questionAnswer,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ),
                                    ],
                                  ),
                                );
                              })),
                    ],
                  ),
                ))),
      ),
    );
  }
}
