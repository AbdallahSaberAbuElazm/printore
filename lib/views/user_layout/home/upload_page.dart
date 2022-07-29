import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:printore/controller/cart_controller.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'dart:math' as math;
import 'package:printore/views/shared/widgets/cart_shopping_icon.dart';
import 'package:printore/views/user_layout/cart/cart_screen.dart';
import 'package:printore/views/user_layout/file_upload/image.render.dart';
import 'package:printore/views/user_layout/file_upload/pdf_render.dart';
import 'package:printore/views/user_layout/file_upload/pick_multi_files.dart';
import 'package:printore/views/user_layout/option/option_screen.dart';
import 'package:provider/provider.dart';
import 'package:printore/model/product/file_model.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  OptionProvider? option;
  User? user = FirebaseAuth.instance.currentUser;

  Timer? _timer;

  List<UploadTask>? taskSnapshot = <UploadTask>[];
  PlatformFile? platformFile;

  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    Get.find<CartController>();
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    option = Provider.of<OptionProvider>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            backgroundColor: MainColor.darkGreyColor,
            title: Styles.appBarText('تحميل الملفات', context),
            centerTitle: true,
            actions: <Widget>[
              InkWell(
                child: CartShoppingIcon(),
                onTap: () => Get.to(() => CartScreen()),
              ),
            ],
            leading: IconButton(
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: option!.advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _drawStepper(context),
                  _drawStepperNameRow(context),
                  _buttonUpload(context),
                  const SizedBox(
                    height: 20,
                  ),
                  // _drawCenter(),
                  _drawShowFileData(context),
                ]),
          ),
        ));
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    option!.advancedDrawerController.value = AdvancedDrawerValue.visible();
    option!.advancedDrawerController.showDrawer();
  }

// draw stepper
  Widget _drawStepper(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 24, right: 12, left: 12),
        child: Row(
          children: [
            Styles.drawContainerOfStepper(color: MainColor.yellowColor),
            Styles.drawLineOfStepper(
                color: Colors.grey.shade400, context: context),
            Styles.drawContainerOfStepper(
              color: Colors.grey.shade400,
            ),
            Styles.drawLineOfStepper(
                color: Colors.grey.shade400, context: context),
            Styles.drawContainerOfStepper(
              color: Colors.grey.shade400,
            ),
          ],
        ));
  }

// write stepper name
  Widget _drawStepperNameRow(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 9, left: 25, right: 25),
        child: Row(
          children: [
            Styles.addStepperName(context: context, stepperName: 'الملفات'),
            const SizedBox(
              width: 75,
            ),
            Styles.addStepperName(
                context: context, stepperName: 'خيارات الطباعة'),
            const SizedBox(
              width: 83,
            ),
            Styles.addStepperName(context: context, stepperName: 'الدفع')
          ],
        ));
  }

  // draw center if no files uploaded
  Widget _drawCenter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 9),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 6,
            child: Image.asset(
              'assets/images/No_uploaded_files.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'قائمة ملفاتك فارغة حتي الأن',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      )),
    );
  }

// showModalButtonSheet
  void _onPressedmodalButton(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: const Color(0xFF737373),
            height: 175,
            child: Container(
                decoration: BoxDecoration(
                    color: MainColor.darkGreyColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: _buildModalNavigationMenu(context)),
          );
        });
  }

// menu of modal sheet
  Widget _buildModalNavigationMenu(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _drawListTileBottomSheet(
                title: 'كاميرا',
                urlImage: 'assets/images/camera.png',
                onPressed: () async {
                  Navigator.pop(context);
                  PickMultiFiles pickMultiFiles = PickMultiFiles();
                  pickMultiFiles.getCameraImage(context);
                },
                context: context),
            _drawListTileBottomSheet(
                title: 'ملفات الجهاز',
                urlImage: 'assets/images/files.png',
                onPressed: () async {
                  PickMultiFiles pickMultiFiles = PickMultiFiles();
                  pickMultiFiles.getPdfAndUpload(context);
                },
                context: context),
          ],
        ),
      ],
    );
  }

  String createCryptoRandomString([int length = 32]) {
    final _random = math.Random.secure();
    var values = List<int>.generate(length, (index) => _random.nextInt(256));
    return base64Url.encode(values);
  }

// listTile for modal sheet
  Widget _drawListTileBottomSheet(
      {required String title,
      required String urlImage,
      required dynamic onPressed,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(children: [
        SizedBox(
            height: (title == 'ملفات الجهاز') ? 70 : 65,
            width: (title == 'ملفات الجهاز') ? 65 : 90,
            child: Image.asset(
              urlImage,
              fit: BoxFit.cover,
            )),
        Text(
          title,
          style: const TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.w300),
        ),
      ]),
    );
  }

// button for upload files
  Widget _buttonUpload(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12, top: 24),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.8,
        height: 47,
        child: ElevatedButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    const EdgeInsets.only(right: 15, left: 10)),
                backgroundColor:
                    MaterialStateProperty.all(MainColor.yellowColor),
                alignment: Alignment.center),
            onPressed: () => _onPressedmodalButton(context),
            child: Center(
              child: Row(
                children: [
                  Text(
                    'إرفع ملفاتك',
                    style: TextStyle(
                        color: MainColor.darkGreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.file_upload,
                    size: 27,
                    color: MainColor.darkGreyColor,
                  ),
                ],
              ),
            )),
      ),
    );
  }

//show file properties
  Widget _drawShowFileData(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 126),
      height: 600,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('files')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: CircularProgressIndicator(
                  color: MainColor.darkGreyColor,
                ),
              );

            default:
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _drawCenter(context);
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 17),
                        height: 163,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 8,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ]),
                        child: Column(children: [
                          ListTile(
                              trailing: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 2, // space between two icons
                                children: <Widget>[
                                  Transform.rotate(
                                      angle: 180 * math.pi / 135,
                                      child: const Icon(
                                        Icons.attach_file,
                                        size: 23.6,
                                      )),
                                  Text(
                                    '${snapshot.data!.docs[index]['numPages']} صفحة',
                                    style: TextStyle(
                                        color: MainColor.darkGreyColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              contentPadding: const EdgeInsets.only(
                                  top: 13, bottom: 13, right: 20, left: 20),
                              leading: Icon(
                                Icons.file_open,
                                size: 50,
                                color: MainColor.darkGreyColor,
                              ),
                              title: Text(
                                '${snapshot.data!.docs[index]['file_name']}',
                                maxLines: 2,
                                style: TextStyle(
                                    color: MainColor.darkGreyColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                              subtitle: Row(
                                children: [
                                  Icon(
                                    Icons.date_range_outlined,
                                    size: 16,
                                    color: MainColor.darkGreyColor,
                                  ),
                                  Text(
                                    '${snapshot.data!.docs[index]['upload_at']}',
                                    style: TextStyle(
                                        color: MainColor.darkGreyColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )),
                          _drawPrintingOptionButtons(context, snapshot, index)
                        ]),
                      );
                    });
              }
          }
        },
      ),
    );
  }

// printing options for files
  Widget _drawPrintingOptionButtons(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    return Container(
      padding: const EdgeInsets.only(left: 9, right: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _optionButton(
              btnName: 'طباعة',
              btnColor: MainColor.yellowColor,
              icon: Icons.print,
              onPressedBtn: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OptionScreen(
                              fileTitle:
                                  snapshot.data!.docs[index]['file_name'] ?? '',
                              fileId: snapshot.data!.docs[index].id,
                              file: FileModel(
                                  customerId: snapshot.data!.docs[index]
                                      ['customer'],
                                  downloadUrl: snapshot.data!.docs[index]
                                      ['downloadUrl'],
                                  fileExtension: snapshot.data!.docs[index]
                                      ['file_extension'],
                                  fileId: snapshot.data!.docs[index].id,
                                  fileName: snapshot.data!.docs[index]
                                      ['file_name'],
                                  numPages: snapshot.data!.docs[index]
                                      ['numPages'],
                                  uploadAt: snapshot.data!.docs[index]
                                      ['upload_at']),
                            )));
              }),
          _optionButton(
              btnName: 'عرض',
              btnColor: const Color(0xff2f72cc),
              icon: Icons.remove_red_eye_outlined,
              onPressedBtn: () {
                String extension = snapshot.data!.docs[index]['file_extension'];
                if (extension == '.jpg' ||
                    extension == '.jpeg' ||
                    extension == '.webp' ||
                    extension == '.png') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageRender(
                                tag: snapshot.data!.docs[index]['file_name'],
                                downloadUrl: snapshot.data!.docs[index]
                                    ['downloadUrl'],
                              )));
                } else {
                  Get.to(() => PdfRender(
                      fileName: snapshot.data!.docs[index]['file_name'],
                      url: snapshot.data!.docs[index]['downloadUrl']));
                }
              }),
          _optionButton(
              btnName: 'إزالة',
              btnColor: const Color(0xff8c3143),
              icon: Icons.delete,
              onPressedBtn: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => Styles.alertDeletingItem(
                    context: context,
                    deleteFile: () async {
                      Navigator.pop(context);
                      User? user = FirebaseAuth.instance.currentUser;
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .collection('files')
                          .doc(snapshot.data!.docs[index].id)
                          .delete();
                      await FirebaseStorage.instance
                          .refFromURL(snapshot.data!.docs[index]['downloadUrl'])
                          .delete();
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }

// button has text and icon
  Widget _optionButton(
      {required String btnName,
      required Color btnColor,
      required IconData icon,
      dynamic onPressedBtn}) {
    return Container(
      width: 120,
      height: 40,
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(btnColor),
          ),
          onPressed: onPressedBtn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                btnName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                width: 7,
              ),
              Icon(
                icon,
                color: Colors.white,
                size: 23,
              ),
            ],
          )),
    );
  }
}
