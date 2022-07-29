import 'package:flutter/material.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:provider/provider.dart';
import 'package:printore/provider/option_provider.dart';

// ignore: must_be_immutable
class AlertDialogForOptions extends StatelessWidget {
  final String optionSelected;
  final dynamic updateOption;
  final String optionName;

  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String fileNameFirebase;

  AlertDialogForOptions({
    Key? key,
    required this.optionName,
    required this.optionSelected,
    required this.updateOption,
    required this.fileNameFirebase,
    required this.controller,
  }) : super(key: key);
  String selected = '';
  @override
  Widget build(BuildContext context) {
    Provider.of<OptionProvider>(context, listen: true);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: ListTile(
            title: Text(optionName,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyText2),
            leading: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          backgroundColor: MainColor.darkGreyColor,
          content: SingleChildScrollView(
            child: SizedBox(
              // Specify some width
              width: MediaQuery.of(context).size.width * .7,
              height: 220,
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(controller.list.length, (index) {
                  return InkWell(
                      onTap: () {
                        updateOption(controller.list[index].optionName);
                        controller.updateOptionName(
                            controller.list[index].optionName);
                        selected = controller.list[index].optionName;
                      },
                      child: Container(
                          width: 70,
                          height: 70,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/paperDesign.png'),
                                  fit: BoxFit.fill),
                              border: Border.all(
                                  width: (selected ==
                                          controller.list[index].optionName)
                                      ? 3
                                      : 2,
                                  color: (selected ==
                                          controller.list[index].optionName)
                                      ? MainColor.yellowColor
                                      : Colors.grey),
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12))),
                          child: Center(
                            child: Text(
                              controller.list[index].optionName,
                              style: (optionSelected ==
                                      controller.list[index].optionName)
                                  ? Theme.of(context).textTheme.headline3
                                  : const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                            ),
                          )));
                }),
              ),
            ),
          ),
        ));
  }
}
