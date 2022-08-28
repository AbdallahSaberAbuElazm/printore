import 'package:flutter/material.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:provider/provider.dart';
import 'package:printore/views/shared/util/util.dart';

class DrawColorSelected extends StatefulWidget {
  const DrawColorSelected({Key? key}) : super(key: key);
  @override
  State<DrawColorSelected> createState() => _DrawColorSelectedState();
}

class _DrawColorSelectedState extends State<DrawColorSelected> {
  List colors = ['أبيض-أسود', 'ألوان'];
  String colorSelected = 'أبيض-أسود';
  late OptionProvider option;
  @override
  Widget build(BuildContext context) {
    option = option = Provider.of<OptionProvider>(context, listen: false);
    return Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.1),
        margin: const EdgeInsets.only(bottom: 9, top: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, right: 19),
              child: Text(
                'لون الطباعة',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            SizedBox(
              height: 140,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 7.6,
                    right: MediaQuery.of(context).size.width / 7.6,
                    bottom: 7),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    Utils.getPaperPrice(context: context);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          colorSelected = colors[index];
                        });
                        option.updateColor(colors[index]);
                        Utils.getPaperPrice(context: context);
                      },
                      child: Container(
                          margin: const EdgeInsets.only(
                              right: 14, left: 14, top: 12, bottom: 12),
                          height: 90,
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: (colorSelected == colors[index])
                                      ? 3
                                      : 1.5,
                                  color: (colorSelected == colors[index])
                                      ? MainColor.yellowColor
                                      : Colors.grey),
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6))),
                          child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 55,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: (colors[index] == 'أبيض-أسود')
                                        ? Image.asset(
                                            'assets/images/Group 2155.png',
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/colours.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Text(
                                    colors[index],
                                    style: (colorSelected == colors[index])
                                        ? TextStyle(
                                            color: MainColor.darkGreyColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)
                                        : const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ]),
                          )),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
