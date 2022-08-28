import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:printore/controller/cart_controller.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/user_layout/home/home.dart';
import 'package:printore/views/user_layout/home/upload_page.dart';
import 'package:printore/views/user_layout/option/option_screen.dart';

class CartItems extends StatefulWidget {
  final bool summary;
  final int index;
  // final dynamic map;
  const CartItems({
    Key? key,
    required this.summary,
    required this.index,
    //  required this.map
  }) : super(key: key);

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  final _noOfCopiesController = TextEditingController();
  late List options;
  final _quantityController = TextEditingController();
  final CartController _cartController = Get.find();

  @override
  void initState() {
    _noOfCopiesController.text = 1.toString();
    // options = [
    //   widget.map[widget.index].optionSize,
    //   widget.map[widget.index].optionPaperType,
    //   widget.map[widget.index].optionLayout,
    //   widget.map[widget.index].optionWrapping,
    //   widget.map[widget.index].optionSide,
    //   widget.map[widget.index].optionColor,
    // ];
    options = [
      _cartController.cart[widget.index].optionSize,
      _cartController.cart[widget.index].optionPaperType,
      _cartController.cart[widget.index].optionLayout,
      _cartController.cart[widget.index].optionWrapping,
      _cartController.cart[widget.index].optionSide,
      _cartController.cart[widget.index].optionColor,
    ];
    _quantityController.text =
        _cartController.cart[widget.index].noOfCopies.toString();
    super.initState();
  }

  @override
  void dispose() {
    _noOfCopiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 17),
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 20,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 8,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ]),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (widget.summary)
                ? const SizedBox.shrink()
                : Container(
                    width: 70,
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Get.off(() => OptionScreen(
                              updateFile: true,
                              file: _cartController.cart[widget.index],
                              fileId: _cartController.cart[widget.index].fileId,
                              fileTitle:
                                  _cartController.cart[widget.index].fileName)),
                          child: SizedBox(
                            width: 20,
                            child: Icon(
                              Icons.mode_edit_outline_sharp,
                              size: 23,
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 11, right: 11),
                          child: Container(
                            width: 1,
                            height: 19,
                            color: MainColor.darkGreyColor,
                          ),
                        ),
                        InkWell(
                          onTap: () => showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  Styles.alertDeletingItem(
                                      context: context,
                                      deleteFile: () async {
                                        Navigator.pop(context);
                                        User? user =
                                            FirebaseAuth.instance.currentUser;
                                        await FirebaseStorage.instance
                                            .refFromURL(
                                                // widget
                                                //   .map[widget.index].downloadUrl
                                                _cartController
                                                    .cart[widget.index]
                                                    .downloadUrl
                                                    .toString())
                                            .delete();
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user!.uid)
                                            .collection('carts')
                                            .doc(
                                                // widget.map[widget.index].cartId,
                                                _cartController
                                                    .cart[widget.index].cartId
                                                    .toString())
                                            .delete();

                                        // widget.map.refresh();
                                        // if (widget.map.length < 1) {
                                        if (_cartController.cart.isEmpty) {
                                          Get.off(() => Home(
                                              recentPage: const UploadPage(),
                                              selectedIndex: 2));
                                        }
                                      })),
                          child: const SizedBox(
                              width: 20,
                              child: Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 155, 25, 25),
                              )),
                        ),
                      ],
                    ),
                  ),
            (widget.summary)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                Styles.alertDeletingItem(
                                    context: context,
                                    deleteFile: () async {
                                      Navigator.pop(context);
                                      User? user =
                                          FirebaseAuth.instance.currentUser;

                                      await FirebaseStorage.instance
                                          .refFromURL(
                                              // widget
                                              //   .map[widget.index].downloadUrl
                                              _cartController.cart[widget.index]
                                                  .downloadUrl
                                                  .toString())
                                          .delete();
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user!.uid)
                                          .collection('carts')
                                          .doc(
                                              // widget.map[widget.index].cartId
                                              _cartController
                                                  .cart[widget.index].cartId
                                                  .toString())
                                          .delete();

                                      // widget.map.refresh();
                                      // if (widget.map.length < 1) {
                                      if (_cartController.cart.isEmpty) {
                                        Get.off(() => Home(
                                            recentPage: const UploadPage(),
                                            selectedIndex: 2));
                                      }
                                      _cartController.getAllPriceOffCart();
                                    })),
                        child: const SizedBox(
                            width: 20,
                            child: Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 155, 25, 25),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 14),
                        child: Row(
                          children: [
                            Container(
                              child: Obx(
                                () => Text(
                                  '${_cartController.cart[widget.index].totalPrice.toString()}',
                                  style: TextStyle(
                                      color: MainColor.darkGreyColor,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            Text(
                              ' جنيه',
                              style: TextStyle(
                                  color: MainColor.darkGreyColor, fontSize: 9),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : const SizedBox.shrink(),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.7,
                child: Text(
                    // widget.map[widget.index].fileName,
                    _cartController.cart[widget.index].fileName.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('خياراتك للطباعة',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: MainColor.darkGreyColor, fontSize: 12)),
                    Stack(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.8,
                          height: 60,
                          child: GridView.count(
                              scrollDirection: Axis.vertical,
                              controller:
                                  ScrollController(keepScrollOffset: false),
                              childAspectRatio: 2.4,
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              children: List.generate(
                                options.length,
                                (index) {
                                  return Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: MainColor.darkGreyColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6)),
                                    ),
                                    child: Center(
                                        child: Text(
                                      options[index],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                      textAlign: TextAlign.center,
                                    )),
                                  );
                                },
                              )),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 1.8,
                            height: 60,
                            child: const Text(
                              'ddddddddddddddddss',
                              style: TextStyle(color: Colors.transparent),
                            )),
                      ],
                    ),
                  ],
                ),
                Transform.translate(
                  offset: const Offset(0, -31),
                  child: Column(
                    children: [
                      Icon(
                        Icons.file_open_outlined,
                        color: MainColor.darkGreyColor,
                        size: 60,
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text('عدد النسخ',
                          style: TextStyle(
                              color: MainColor.darkGreyColor, fontSize: 10)),
                      const SizedBox(
                        height: 7,
                      ),
                      Container(
                        height: 35,
                        width: 100,
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: MainColor.darkGreyColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                        ),
                        child: InkWell(
                          onTap: () => Get.defaultDialog(
                              backgroundColor: MainColor.darkGreyColor,
                              title: 'من فضلك حدد الكمية ',
                              titlePadding: const EdgeInsets.only(top: 30),
                              titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                              actions: [
                                Transform.translate(
                                  offset: const Offset(0, -20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.only(
                                                    right: 27,
                                                    left: 27,
                                                    top: 4,
                                                    bottom: 4)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    MainColor.yellowColor),
                                            alignment: Alignment.center),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'إلغاء',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.only(
                                                    right: 25,
                                                    left: 25,
                                                    top: 4,
                                                    bottom: 4)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    MainColor.yellowColor),
                                            alignment: Alignment.center),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          User? user =
                                              FirebaseAuth.instance.currentUser;
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user!.uid)
                                              .collection('carts')
                                              .doc(_cartController
                                                  .cart[widget.index].cartId)
                                              .update({
                                            'noOfCopies': int.parse(
                                                _quantityController.text),
                                            'totalPrice': (_cartController
                                                    .cart[widget.index]
                                                    .price!) *
                                                int.parse(
                                                    _quantityController.text)
                                          });

                                          _cartController.updateQuantity(
                                              widget.index,
                                              int.parse(
                                                  _quantityController.text));
                                          _cartController.getAllPriceOffCart();
                                        },
                                        child: Text(
                                          'تأكيد',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * .7,
                                height: MediaQuery.of(context).size.height / 6,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 8),
                                        child: Text(
                                          'الكمية',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Container(
                                        height: 46,
                                        width: 182,
                                        padding: EdgeInsets.zero,
                                        margin: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.white),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6)),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  _cartController
                                                      .decreaseQuantity(
                                                          widget.index);

                                                  _quantityController.text =
                                                      _cartController
                                                          .cart[widget.index]
                                                          .noOfCopies
                                                          .toString();
                                                },
                                                child: const SizedBox(
                                                  width: 54,
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 21,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 1,
                                                height: 50,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 64,
                                                child: TextField(
                                                  controller:
                                                      _quantityController,
                                                  textAlign: TextAlign.center,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <
                                                      TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp(r'[0-9]')),
                                                  ],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  decoration: InputDecoration(
                                                      fillColor: MainColor
                                                          .darkGreyColor,
                                                      focusColor: MainColor
                                                          .darkGreyColor,
                                                      hoverColor: MainColor
                                                          .darkGreyColor,
                                                      focusedBorder:
                                                          const UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white))),
                                                ),
                                              ),
                                              Container(
                                                width: 1,
                                                height: 50,
                                                color: Colors.white,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _cartController
                                                      .increaseQuantity(
                                                          widget.index);
                                                  _quantityController.text =
                                                      _cartController
                                                          .cart[widget.index]
                                                          .noOfCopies
                                                          .toString();
                                                },
                                                child: const SizedBox(
                                                  width: 54,
                                                  child: IconButton(
                                                      onPressed: null,
                                                      icon: Icon(
                                                        Icons.add,
                                                        size: 21,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ]),
                              )),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 32,
                                  child: Icon(
                                    Icons.add,
                                    size: 15,
                                    color: MainColor.darkGreyColor,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 35,
                                  color: MainColor.darkGreyColor,
                                ),
                                Flexible(
                                  child: SizedBox(
                                      width: 32,
                                      child: Obx(
                                        () => Text(
                                          ' ${_cartController.cart[widget.index].noOfCopies}',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      )),
                                ),
                                Container(
                                  width: 1,
                                  height: 35,
                                  color: MainColor.darkGreyColor,
                                ),
                                SizedBox(
                                  width: 32,
                                  child: Icon(
                                    Icons.remove,
                                    size: 15,
                                    color: MainColor.darkGreyColor,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}
