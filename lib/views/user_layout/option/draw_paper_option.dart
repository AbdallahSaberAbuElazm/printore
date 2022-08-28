import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/user_layout/option/alert_dialog_for_layout_wrapping_options.dart';
import 'package:provider/provider.dart';

class DrawPaperOption extends StatefulWidget {
  final String optionSelected;
  final dynamic updateOption;
  final String optionName;
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String fileNameFirebase;
  const DrawPaperOption(
      {Key? key,
      required this.optionName,
      required this.optionSelected,
      required this.updateOption,
      required this.fileNameFirebase,
      // required this.streamData,
      required this.controller})
      : super(key: key);

  @override
  State<DrawPaperOption> createState() => _DrawPaperOptionState();
}

class _DrawPaperOptionState extends State<DrawPaperOption> {
  // ignore: prefer_typing_uninitialized_variables
  var option;

  @override
  void initState() {
    if (widget.optionName == 'تخطييط') {
      widget.controller
          .updateNoOfPagesInLayout(widget.controller.list[0].layoutNumber);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    option = Provider.of<OptionProvider>(context, listen: false);
    return Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.1),
        margin: const EdgeInsets.only(bottom: 9, top: 8),
        child: Column(children: [
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                color: MainColor.darkGreyColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 8,
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.optionName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Transform.translate(
                      offset: const Offset(-8, 0),
                      child: TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    AlertDialogForOptionsLayoutsWrapping(
                                      controller: widget.controller,
                                      // streamData: widget.streamData,
                                      updateOption: widget.updateOption,
                                      optionName: widget.optionName,
                                      fileNameFirebase: widget.fileNameFirebase,
                                      optionSelected: widget.optionSelected,
                                    ));
                          },
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.asset(
                                'assets/images/Icon ionic-ios--mdpi.png'),
                          )),
                    ),
                  ]),
            ),
          ),
          Container(
              color: Colors.white,
              width: double.infinity,
              height: 130,
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 9, right: 9),
                      child: (widget.controller.list.value != null)
                          ? Obx(
                              () => ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.controller.list.length,
                                  itemBuilder: (context, index) {
                                    return Obx(
                                      () => InkWell(
                                        onTap: () {
                                          widget.updateOption(widget.controller
                                              .list[index].optionName);
                                          widget.controller.updateOptionName(
                                              widget.controller.list[index]
                                                  .optionName);
                                          widget.controller.updateOptionPrice(
                                              widget.controller.list[index]
                                                  .price);
                                          if (widget.optionName == 'تخطييط') {
                                            widget.controller
                                                .updateNoOfPagesInLayout(widget
                                                    .controller
                                                    .list[index]
                                                    .layoutNumber);
                                          }
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              right: 8,
                                              left: 8,
                                              top: 12,
                                              bottom: 12),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4.1,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    '${widget.controller.list[index].downloadUrl}',
                                                  ),
                                                  fit: BoxFit.fill),
                                              border: Border.all(
                                                  width: (widget
                                                              .controller
                                                              .optionNameSelected
                                                              .value ==
                                                          widget
                                                              .controller
                                                              .list[index]
                                                              .optionName)
                                                      ? 3
                                                      : 1.5,
                                                  color: (widget
                                                              .controller
                                                              .optionNameSelected
                                                              .value ==
                                                          widget
                                                              .controller
                                                              .list[index]
                                                              .optionName)
                                                      ? MainColor.yellowColor
                                                      : Colors.grey),
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(6))),
                                          // child:

                                          //     Center(
                                          //   child: Text(
                                          //     widget.controller.list[index]
                                          //         .optionName,
                                          //     style: (widget
                                          //                 .controller
                                          //                 .optionNameSelected
                                          //                 .value ==
                                          //             widget
                                          //                 .controller
                                          //                 .list[index]
                                          //                 .optionName)
                                          //         ? TextStyle(
                                          //             color: MainColor
                                          //                 .darkGreyColor,
                                          //             fontSize: 25,
                                          //             fontWeight:
                                          //                 FontWeight.w400)
                                          //         : const TextStyle(
                                          //             color: Colors.grey,
                                          //             fontSize: 25,
                                          //             fontWeight:
                                          //                 FontWeight.w400),
                                          //   ),
                                          // )
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          : const SizedBox.shrink())))
        ]));
  }
}
