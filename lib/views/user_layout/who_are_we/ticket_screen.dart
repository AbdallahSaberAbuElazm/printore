import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/controller/ticket_controller.dart';
import 'package:printore/controller/ticket_type_controller.dart';
import 'package:printore/model/ticket/ticket.dart';

import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/util.dart';

class Complaint {
  static final _formKey = GlobalKey<FormState>();
  static final TicketTypeController _ticketTypesController = Get.find();
  static final TicketController _ticketController =
      Get.find<TicketController>();

  static Set<String> seen = {};
  static User? user = FirebaseAuth.instance.currentUser;
  static final TextEditingController _messageController =
      TextEditingController();
  static showComplaintDialog({required BuildContext context}) {
    for (int i = 0; i < _ticketTypesController.list.length; i++) {
      seen.add(_ticketTypesController.list[i].ticketType.toString());
    }
    List<String> listTicketTypes = seen.toList();
    _ticketTypesController.updateTicketTypeChoosed(
        value: _ticketTypesController.list[0].ticketType.toString());

    return showDialog(
        context: context,
        builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: Form(
                  key: _formKey,
                  child: AlertDialog(
                    title: Row(
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 25,
                            )),
                        Text(
                          'كتابة شكوي',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                    backgroundColor: MainColor.darkGreyColor,
                    content: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.8,
                      child: ListView(
                          // mainAxisSize: MainAxisSize.min,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Obx(
                                () => DropdownButton<String>(
                                  dropdownColor: MainColor.darkGreyColor,
                                  focusColor: MainColor.darkGreyColor,
                                  value: _ticketTypesController
                                      .ticketTypeChoosed.value,
                                  icon: const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    size: 28,
                                    color: Color.fromARGB(255, 184, 182, 182),
                                  ),
                                  elevation: 9,
                                  style: TextStyle(color: Colors.white),
                                  underline: Container(
                                    height: 0.3,
                                    color: Colors.white,
                                  ),
                                  onChanged: (newValue) {
                                    _ticketTypesController
                                        .updateTicketTypeChoosed(
                                            value: newValue!);
                                  },
                                  items: listTicketTypes
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          value,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text('الرسالة',
                                  style: Theme.of(context).textTheme.bodyText2,
                                  textAlign: TextAlign.right),
                            ),
                            Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              ),
                              color: MainColor.darkGreyColor,
                              margin: const EdgeInsets.only(bottom: 9, top: 8),
                              child: TextFormField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                      width: 0.3,
                                      color: Colors.white,
                                    )),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.3),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.3),
                                    ),
                                    fillColor: Colors.white,
                                    focusColor: Colors.white,
                                    hoverColor: Colors.white,
                                    iconColor: Colors.white),
                                minLines: 4,
                                cursorColor: Colors.white,
                                style: Theme.of(context).textTheme.bodyText2,
                                keyboardType: TextInputType.multiline,
                                maxLines: 6,
                              ),
                            ),
                          ]),
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Center(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: MainColor.yellowColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    _messageController.text.isNotEmpty) {
                                  _ticketController.sendTicket(Ticket(
                                    ticketType: _ticketTypesController
                                        .ticketTypeChoosed.value,
                                    message: _messageController.text,
                                    userId: user!.uid,
                                    status: 'waiting',
                                  ).toMap());
                                  Utils.snackBar(
                                      context: context,
                                      msg:
                                          'لقد تم ارسال شكوتك وسنتواصل معك قريبا');
                                  _messageController.text = '';
                                } else {
                                  Utils.snackBar(
                                      context: context,
                                      msg: 'من فضلك ادخل الرسالة');
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  'إرسل الآن',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
