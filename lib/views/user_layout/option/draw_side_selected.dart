import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/controller/side_color_controller.dart';
import 'package:printore/controller/size_controller.dart';
import 'package:printore/views/shared/styles/colors.dart';

class DrawSideSelected extends StatefulWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> streamSide;
  const DrawSideSelected({Key? key, required this.streamSide})
      : super(key: key);

  @override
  State<DrawSideSelected> createState() => _DrawSideSelectedState();
}

class _DrawSideSelectedState extends State<DrawSideSelected> {
  int count = 1;
  final _sideController = Get.find<SideColorController>();
  final _sizeController = Get.find<SizeController>();
  @override
  Widget build(BuildContext context) {
    List<QueryDocumentSnapshot<Object?>> list = [];
    // var option = Provider.of<OptionProvider>(context);
    if (_sizeController.optionNameSelected.value != 'A5' ||
        _sizeController.optionNameSelected.value != 'A6') {
      setState(() {
        count = 0;
      });
    }
    return (count > 0)
        ? Card(
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
                  child: StreamBuilder<QuerySnapshot>(
                      stream: widget.streamSide,
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('');
                        }

                        if (snapshot.data!.docs.isNotEmpty) {
                          list = snapshot.data!.docs;

                          return ListView.builder(
                            padding: const EdgeInsets.only(
                                left: 35, right: 35, bottom: 7),
                            scrollDirection: Axis.horizontal,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return Obx(
                                () => InkWell(
                                  onTap: () => _sideController.updateOptionSide(
                                      list[index]['sideName']),
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 7, left: 7, top: 12, bottom: 12),
                                    height: 60,
                                    width:
                                        MediaQuery.of(context).size.width / 2.8,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.5,
                                            color: MainColor.darkGreyColor),
                                        color: (_sideController.side ==
                                                list[index]['sideName'])
                                            ? MainColor.darkGreyColor
                                            : Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(6))),
                                    child: Center(
                                      child: Text(
                                        list[index]['sideName'],
                                        style: (_sideController.side ==
                                                list[index]['sideName'])
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
                            },
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                )
              ],
            ))
        : const SizedBox.shrink();
  }
}
