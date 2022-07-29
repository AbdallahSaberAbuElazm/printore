import 'package:flutter/material.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';

class PrintOfficeWorkingHours extends StatefulWidget {
  const PrintOfficeWorkingHours({Key? key}) : super(key: key);

  @override
  State<PrintOfficeWorkingHours> createState() =>
      _PrintOfficeWorkingHoursState();
}

class _PrintOfficeWorkingHoursState extends State<PrintOfficeWorkingHours> {
  Color _color = const Color(0xfff93369);
  String _status = 'مغلق';
  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: ListView(
              padding: const EdgeInsets.only(top: 70, left: 12, right: 12),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Styles.monthAr(),
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Icon(
                      Icons.date_range_outlined,
                      color: MainColor.darkGreyColor,
                      size: 28,
                    )
                  ],
                ),
                _workingHours(),
                _buttonOnOff(),
              ]),
        ));
  }

  Widget _workingHours() {
    return SizedBox(
        width: double.infinity,
        height: 140,
        child: Center(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Styles.weekDays.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        const EdgeInsets.only(left: 16, top: 12, bottom: 12),
                    width: MediaQuery.of(context).size.width / 3.8,
                    decoration: BoxDecoration(
                        color: (Styles.dayAr() == Styles.weekDays[index])
                            ? MainColor.yellowColor
                            : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 4),
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Styles.weekDays[index],
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '7 صباحا إلي 2 ظهرا - 4 عصرا إلي 10 مساء',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MainColor.darkGreyColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })));
  }

  Widget _buttonOnOff() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
      child: InkWell(
        onTap: () {
          if (_color == const Color(0xfff93369)) {
            setState(() {
              _color = MainColor.yellowColor;
              _status = 'مفتوح';
            });
          } else {
            setState(() {
              _color = const Color(0xfff93369);
              _status = 'مغلق';
            });
          }
        },
        child: Center(
            child: Column(
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                  color: const Color(0xfff4f5f6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  shape: BoxShape.circle),
              child: Icon(
                Icons.power_settings_new,
                color: _color,
                size: 140,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              _status,
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        )),
      ),
    );
  }
}
