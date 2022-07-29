import 'package:flutter/material.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';

class ImageRender extends StatelessWidget {
  final String tag;
  final String downloadUrl;
  const ImageRender({Key? key, required this.tag, required this.downloadUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Hero(
        tag: tag,
        child: Image.network(downloadUrl,
            loadingBuilder: (context, child, loadingProgress) {
          return loadingProgress == null
              ? child
              : CircularProgressIndicator(color: MainColor.darkGreyColor);
        }));
  }
}
