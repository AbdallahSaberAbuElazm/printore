import 'package:flutter/material.dart';
import 'package:printore/model/product/file_model.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'dart:math' as math;
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/user_layout/home/home.dart';
import 'package:printore/views/user_layout/home/upload_page.dart';
import 'package:printore/views/user_layout/option/draw_option_card.dart';
import 'package:provider/provider.dart';

class OptionScreen extends StatelessWidget {
  final String? fileTitle;
  final String? fileId;
  final FileModel file;
  OptionScreen(
      {Key? key,
      required this.fileTitle,
      required this.fileId,
      required this.file})
      : super(key: key);
  OptionProvider? option;
  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: MainColor.darkGreyColor,
              title: Styles.appBarText('خيارات الطباعة', context),
              centerTitle: true,
              leadingWidth: 100,
              leading: TextButton(
                  child: Text(
                    'إعادة تعيين',
                    style:
                        TextStyle(color: MainColor.yellowColor, fontSize: 14),
                  ),
                  onPressed: () {
                    option =
                        Provider.of<OptionProvider>(context, listen: false);
                    option!.restOptions();
                  }),
              actions: [
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(
                                    recentPage: const UploadPage(),
                                    selectedIndex: 2))),
                        icon: Transform.rotate(
                          angle: 180 * math.pi / 180,
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 26,
                          ),
                        )))
              ],
            ),
            body: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _drawStepper(context),
                    Styles.drawStepperNameRow(context: context),
                    const SizedBox(
                      height: 12,
                    ),
                    Center(
                      child: Text(
                        (fileTitle!.length > 36)
                            ? fileTitle!.substring(1, 36).toString()
                            : fileTitle.toString(),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    DrawOptionCard(
                      fileId: fileId,
                      fileModel: file,
                    )
                  ]),
            )));
  }

  Widget _drawStepper(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 24, right: 12, left: 12),
        child: Row(
          children: [
            Styles.drawContainerOfStepper(color: MainColor.yellowColor),
            Styles.drawLineOfStepper(
                color: MainColor.yellowColor, context: context),
            Styles.drawContainerOfStepper(
              color: MainColor.yellowColor,
            ),
            Styles.drawLineOfStepper(
                color: Colors.grey.shade400, context: context),
            Styles.drawContainerOfStepper(
              color: Colors.grey.shade400,
            ),
          ],
        ));
  }
}
