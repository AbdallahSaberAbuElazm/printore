import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/controller/side_color_controller.dart';
import 'package:printore/views/shared/styles/colors.dart';

class DrawSideSelected extends StatefulWidget {
  final controller;
  final dynamic updateOption;
  DrawSideSelected({
    Key? key,
    required this.controller,
    required this.updateOption,
  }) : super(key: key);

  @override
  State<DrawSideSelected> createState() => _DrawSideSelectedState();
}

class _DrawSideSelectedState extends State<DrawSideSelected> {
  int count = 1;
  final _sideController = Get.find<SideColorController>();
  @override
  void initState() {
    _sideController.getPriceSide(widget.controller.list[0].price);
    _sideController.getNoOfSide(widget.controller.list[0].side);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var option = Provider.of<OptionProvider>(context);
    // if (_sizeController.optionNameSelected.value != 'A5' ||
    //     _sizeController.optionNameSelected.value != 'A6') {
    //   setState(() {
    //     count = 0;
    //   });
    // }
    // return (count > 0)
    //     ?

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
                  'جانب الطباعة',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              SizedBox(
                  height: 77,
                  width: double.infinity,
                  child: Obx(() => ListView.builder(
                      padding:
                          const EdgeInsets.only(left: 35, right: 35, bottom: 7),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.controller.list.length,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => InkWell(
                            onTap: () {
                              _sideController.updateOptionSide(
                                  widget.controller.list[index].sideName);
                              widget.updateOption(
                                  widget.controller.list[index].sideName);
                              _sideController.getPriceSide(
                                  widget.controller.list[index].price);
                              _sideController.getNoOfSide(
                                  widget.controller.list[index].side);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  right: 7, left: 7, top: 12, bottom: 12),
                              height: 60,
                              width: MediaQuery.of(context).size.width / 2.8,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5,
                                      color: MainColor.darkGreyColor),
                                  color: (_sideController.side ==
                                          widget
                                              .controller.list[index].sideName)
                                      ? MainColor.darkGreyColor
                                      : Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6))),
                              child: Center(
                                child: Text(
                                  widget.controller.list[index].sideName,
                                  style: (_sideController.side ==
                                          widget
                                              .controller.list[index].sideName)
                                      ? const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)
                                      : TextStyle(
                                          color: MainColor.darkGreyColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        );
                      })))
            ]));

    // : const SizedBox.shrink();
  }
}
