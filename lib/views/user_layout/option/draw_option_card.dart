import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/controller/cart_controller.dart';

import 'package:printore/controller/layout_controller.dart';
import 'package:printore/controller/paper_price_controller.dart';
import 'package:printore/controller/paper_type_controller.dart';
import 'package:printore/controller/side_color_controller.dart';
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
  // final SizeController _sizeController = Get.find<SizeController>();
  // final PaperTypeController _paperTypeController =
  //     Get.find<PaperTypeController>();
  final WrappingController _wrappingController = Get.find<WrappingController>();
  final LayoutController _layoutController = Get.find<LayoutController>();
  final PaperPriceController _paperPriceController =
      Get.find<PaperPriceController>();
  final SideColorController _sideColorController =
      Get.find<SideColorController>();
  final CartController _cartController = Get.find();

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
              optionSelected: (widget.statusFile)
                  ? widget.fileModel.optionSize
                  : option!.sizeSelected,
            ),
            DrawSizePaperType(
              controller: Get.find<PaperTypeController>(),
              updateOption: option!.updatePaperTypeSelected,
              optionName: 'نوع الورقة',
              fileNameFirebase: 'optionName',
              optionSelected: (widget.statusFile)
                  ? widget.fileModel.optionPaperType
                  : option!.paperTypeSelected,
            ),
            const DrawColorSelected(),
            DrawPaperOption(
              controller: _layoutController,
              updateOption: option!.updateLayoutSelected,
              optionName: 'تخطييط',
              fileNameFirebase: 'optionName',
              optionSelected: (widget.statusFile)
                  ? widget.fileModel.optionLayout
                  : option!.layoutSelected,
            ),
            DrawPaperOption(
                controller: _wrappingController,
                optionName: 'تغليف',
                fileNameFirebase: 'optionName',
                optionSelected: (widget.statusFile)
                    ? widget.fileModel.optionWrapping
                    : option!.wrappingSelected,
                updateOption: option!.updateWrappingSelected),
            DrawSideSelected(
                controller: _sideColorController,
                updateOption: option!.updateSideSelected),
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
            User? user = FirebaseAuth.instance.currentUser;
            OptionModel optionModel = OptionModel(
                optionLayout: option!.layoutSelected,
                optionSize: option!.sizeSelected,
                optionPaperType: option!.paperTypeSelected,
                optionSide: _sideColorController.side.value,
                optionWrapping: option!.wrappingSelected,
                optionNote: (_noteController.text.isNotEmpty)
                    ? _noteController.text
                    : (widget.statusFile)
                        ? widget.fileModel.optionNote
                        : '',
                optionColor: option!.colorSelected);

            final filePrice = _cartController.calculateFilePrice(
                numOfPages: widget.fileModel.numPages,
                numOfCopies: 1,
                paperPrice: _paperPriceController.paperPrice.last.price,
                layoutNumOfPages: _layoutController.layoutNumber.value,
                layoutPrice: _layoutController.layoutPrice.value,
                wrappingPrice: _wrappingController.wrappingPrice.value,
                side: _sideColorController.noOfSide.value,
                priceSide: _sideColorController.priceSide.value);

            Map<String, dynamic> productMap = {};
            productMap.addAll(widget.fileModel.toMap());
            productMap.addAll(optionModel.toMap());
            productMap.addAll({
              'noOfCopies': 1,
              'ordered': false,
              'finished': false,
              'price': filePrice,
              'totalPrice': filePrice
            });

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

            if (widget.statusFile == false) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('files')
                  .doc(widget.fileId)
                  .delete();
            }
            Get.off(() => CartScreen());
            CircularProgressIndicator(
              color: MainColor.darkGreyColor,
            );
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
