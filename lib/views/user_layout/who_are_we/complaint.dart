import 'package:flutter/material.dart';
import 'package:printore/views/shared/styles/colors.dart';

class Complaint {
  static final _formKey = GlobalKey<FormState>();
  static showComplaintDialog({required BuildContext context}) {
    final TextEditingController controller = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
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
                          child: DropdownButton<String>(
                            value: 'السبت',
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
                              newValue = '';
                            },
                            items: <String>[
                              'السبت',
                              'الأحد',
                              'الاثنين',
                              'الثلاثاء',
                              'الأربعاء',
                              'الخميس',
                              'الجمعة'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              );
                            }).toList(),
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
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          color: MainColor.darkGreyColor,
                          margin: const EdgeInsets.only(bottom: 9, top: 8),
                          child: TextFormField(
                            controller: controller,
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
                            maxLines: null,
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
                            if (_formKey.currentState!.validate()) {}
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
            )));
  }
}
