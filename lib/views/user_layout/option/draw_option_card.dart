import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:printore/controller/layout_controller.dart';
import 'package:printore/controller/paper_type_controller.dart';
import 'package:printore/controller/size_controller.dart';
import 'package:printore/controller/wrapping_controller.dart';

import 'package:printore/model/product/option/option.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/user_layout/cart/cart_screen.dart';
import 'package:printore/views/user_layout/option/draw_color_selected.dart';
import 'package:printore/views/user_layout/option/draw_paper_option.dart';
import 'package:printore/views/user_layout/option/draw_side_selected.dart';
import 'package:printore/views/user_layout/option/draw_size_paper_type.dart';
import 'package:provider/provider.dart';

class DrawOptionCard extends StatefulWidget {
  final String? fileId;
  final fileModel;
  final statusFile;
  const DrawOptionCard(
      {Key? key,
      required this.fileId,
      required this.fileModel,
      required this.statusFile})
      : super(key: key);

  @override
  State<DrawOptionCard> createState() => _DrawOptionCardState();
}

class _DrawOptionCardState extends State<DrawOptionCard> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? streamData;
  OptionProvider? option;
  final TextEditingController _noteController = TextEditingController();
  final SizeController sizeController = Get.find<SizeController>();
  final PaperTypeController paperTypeController =
      Get.find<PaperTypeController>();
  final WrappingController wrappingController = Get.find<WrappingController>();
  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    option = Provider.of<OptionProvider>(context, listen: false);

    return Container(
        width: double.infinity,
        height: 612,
        padding:
            const EdgeInsets.only(top: 20, right: 12, left: 12, bottom: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            DrawSizePaperType(
              controller: Get.find<SizeController>(),
              updateOption: option!.updateSizeSelected,
              optionName: 'حجم الورقة',
              fileNameFirebase: 'optionName',
              optionSelected: option!.sizeSelected,
            ),
            DrawSizePaperType(
              controller: Get.find<PaperTypeController>(),
              updateOption: option!.updatePaperTypeSelected,
              optionName: 'نوع الورقة',
              fileNameFirebase: 'optionName',
              optionSelected: option!.paperTypeSelected,
            ),
            const DrawColorSelected(),
            DrawPaperOption(
              controller: Get.find<LayoutController>(),
              updateOption: option!.updateLayoutSelected,
              optionName: 'تخطييط',
              fileNameFirebase: 'optionName',
              optionSelected: option!.layoutSelected,
            ),
            DrawPaperOption(
                controller: Get.find<WrappingController>(),
                optionName: 'تغليف',
                fileNameFirebase: 'optionName',
                optionSelected: option!.wrappingSelected,
                updateOption: option!.updateWrappingSelected),
            DrawSideSelected(
              streamSide:
                  FirebaseFirestore.instance.collection('sides').snapshots(),
            ),
            Styles.addNote(context: context, controller: _noteController),
            _addButton()
          ],
        ));
  }

  Widget _addButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 21),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            OptionModel optionModel = OptionModel(
                optionLayout: option!.layoutSelected,
                optionSize: option!.sizeSelected,
                optionPaperType: option!.paperTypeSelected,
                optionSide: option!.sideSelected,
                optionWrapping: option!.wrappingSelected,
                optionNote: (_noteController.text.isNotEmpty)
                    ? _noteController.text
                    : widget.fileModel.optionNote,
                optionColor: option!.colorSelected);
            // Product product = Product(
            //     file: widget.fileModel, option: optionModel, noOfCopies: 1);
            User? user = FirebaseAuth.instance.currentUser;
            // _cartController = Get.find<CartController>();
            // _cartController.addProduct(product);

            Map<String, dynamic> productMap = {};
            productMap.addAll(widget.fileModel.toMap());
            productMap.addAll(optionModel.toMap());
            productMap
                .addAll({'noOfCopies': 1, 'ordered': false, 'finished': false});

            (widget.statusFile)
                ? await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .collection('carts')
                    .doc(widget.fileModel.fileId)
                    .update(productMap)
                : await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .collection('carts')
                    .doc(widget.fileId)
                    .set(productMap);

            if (!widget.statusFile == false) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('files')
                  .doc(widget.fileId)
                  .delete();
            }
            Get.off(() => CartScreen());
          },
          style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.only(right: 15, left: 10)),
              backgroundColor: MaterialStateProperty.all(MainColor.yellowColor),
              alignment: Alignment.center),
          child: Text(
            'أضف إلي سلة مطبوعاتك',
            style: TextStyle(
                color: MainColor.darkGreyColor,
                fontSize: 14,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
