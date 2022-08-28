import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/controller/review_controller.dart';
import 'package:printore/model/review/review.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/util/util.dart';
import 'package:printore/views/shared/widgets/rating_builder.dart';
import 'package:printore/views/user_layout/home/home.dart';
import 'package:printore/views/user_layout/home/home_page.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List options = [];
  final ReviewController _reviewController = Get.find<ReviewController>();
  final TextEditingController _noteController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _reviewController.updateNewRating(0.0);
    super.initState();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: MainColor.darkGreyColor,
              title: Styles.appBarText('تقييمك للخدمة', context),
              centerTitle: true,
              leading: const SizedBox.shrink(),
              actions: [
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      onPressed: () => Get.off(
                        () => Home(
                          recentPage: const HomePage(),
                          selectedIndex: 0,
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 26,
                      ),
                    )),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.only(
                  top: 30, bottom: 15, right: 12, left: 12),
              children: [
                Text(
                  'قيم تجربتك للخدمة',
                  style: TextStyle(
                      color: MainColor.darkGreyColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  'هل أنت راض عن الخدمة؟',
                  style: TextStyle(
                      color: MainColor.darkGreyColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Obx(
                    () => RatingBuilder(
                        rating: _reviewController.newRating.value,
                        itemSize: 45),
                  ),
                ),
                Divider(
                  height: 2,
                  color: MainColor.darkGreyColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'من فضلك شاركنا ما يمكننا تحسينه',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _drawOption(optionTitle: 'الوقت'),
                    _drawOption(optionTitle: 'سرعة التنفيذ')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _drawOption(optionTitle: 'جودة الطباعة'),
                    _drawOption(optionTitle: 'حسن المعاملة')
                  ],
                ),
                _addNote(),
                _sendButton(),
              ],
            )));
  }

  Widget _sendButton() {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 5,
          right: MediaQuery.of(context).size.width / 5),
      height: 50,
      child: Obx(
        () => ElevatedButton(
          onPressed: (_reviewController.newRating.value > 0.0)
              ? () {
                  _reviewController.uploadReview(
                    toMap: Review(
                            userId: user!.uid.toString(),
                            rating:
                                _reviewController.newRating.value.toString(),
                            improvements: options,
                            opinions: _noteController.text)
                        .toMap(),
                  );
                  Utils.snackBar(
                      context: context,
                      msg: 'شكرا يا فندم علي تقييمك لخدماتنا وتم ارسال تقييمك');
                  _reviewController.updateNewRating(0.0);
                  _noteController.text = '';
                  setState(() {
                    options.clear();
                  });
                }
              : () {
                  Utils.snackBar(context: context, msg: 'من فضلك ادخل تقييمك');
                },
          style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.only(right: 15, left: 10)),
              backgroundColor:
                  MaterialStateProperty.all(MainColor.darkGreyColor),
              alignment: Alignment.center),
          child: const Text(
            'إرسال',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _addNote() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        color: Colors.white.withOpacity(0.5),
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.1),
        margin: const EdgeInsets.only(bottom: 9, top: 8),
        child: TextFormField(
          controller: _noteController,
          decoration: InputDecoration(
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              fillColor: MainColor.darkGreyColor,
              focusColor: MainColor.darkGreyColor,
              hoverColor: MainColor.darkGreyColor,
              iconColor: MainColor.darkGreyColor,
              hintText: 'كيف يمكننا التحسين في رأيك ؟',
              hintStyle:
                  TextStyle(color: MainColor.darkGreyColor, fontSize: 12)),
          minLines: 4,
          cursorColor: MainColor.darkGreyColor,
          style: Theme.of(context).textTheme.bodyText1,
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
      ),
    );
  }

  Widget _drawOption({required String optionTitle}) {
    return InkWell(
      onTap: () {
        setState(() {
          if (!options.contains(optionTitle)) {
            options.add(optionTitle);
          } else {
            options.remove(optionTitle);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
        margin: const EdgeInsets.all(6),
        width: 150,
        decoration: BoxDecoration(
            color: options.contains(optionTitle)
                ? MainColor.darkGreyColor
                : Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 8,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ]),
        child: Center(
            child: Text(
          optionTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: options.contains(optionTitle)
                  ? Colors.white
                  : MainColor.darkGreyColor,
              fontSize: 13,
              fontWeight: FontWeight.w500),
        )),
      ),
    );
  }
}
