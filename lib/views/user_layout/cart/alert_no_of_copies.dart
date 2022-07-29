import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/controller/cart_controller.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';

class AlertNoOfCopies extends StatefulWidget {
  final int index;
  const AlertNoOfCopies({Key? key, required this.index}) : super(key: key);

  @override
  State<AlertNoOfCopies> createState() => _AlertNoOfCopiesState();
}

class _AlertNoOfCopiesState extends State<AlertNoOfCopies> {
  final _quantityController = TextEditingController();
  final CartController _cartController = Get.find();
  @override
  void initState() {
    _quantityController.text =
        _cartController.cart[widget.index].noOfCopies.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
            backgroundColor: MainColor.darkGreyColor,
            title: const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'من فضلك حدد الكمية ',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
            actions: [
              Transform.translate(
                offset: const Offset(0, -20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(
                                  right: 25, left: 25, top: 4, bottom: 4)),
                          backgroundColor:
                              MaterialStateProperty.all(MainColor.yellowColor),
                          alignment: Alignment.center),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        User? user = FirebaseAuth.instance.currentUser;
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .collection('carts')
                            .doc(_cartController.cart[widget.index].cartId)
                            .update({'noOfCopies': _quantityController.text});
                        _cartController.updateQuantity(
                            widget.index, int.parse(_quantityController.text));
                      },
                      child: Text(
                        'تأكيد',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(
                                  right: 25, left: 25, top: 4, bottom: 4)),
                          backgroundColor:
                              MaterialStateProperty.all(MainColor.yellowColor),
                          alignment: Alignment.center),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'إلغاء',
                        style: Theme.of(context).textTheme.bodyText2,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 54,
                              child: IconButton(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.add,
                                    size: 21,
                                    color: Colors.white,
                                  )),
                            ),
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 64,
                              child: TextFormField(
                                controller: _quantityController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                                    fillColor: MainColor.darkGreyColor,
                                    focusColor: MainColor.darkGreyColor,
                                    hoverColor: MainColor.darkGreyColor,
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white))),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 54,
                              child: IconButton(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.remove,
                                    size: 21,
                                    color: Colors.white,
                                  )),
                            ),
                          ]),
                    ),
                  ]),
            )));
  }
}
