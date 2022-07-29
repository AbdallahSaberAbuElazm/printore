import 'package:flutter/material.dart';
// import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// ignore: must_be_immutable
class PdfRender extends StatefulWidget {
  String fileName;
  String url;
  PdfRender({Key? key, required this.fileName, required this.url})
      : super(key: key);

  @override
  State<PdfRender> createState() => _PdfRenderState();
}

class _PdfRenderState extends State<PdfRender> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  // final PdfViewerController _pdfViewerController = PdfViewerController();
  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MainColor.darkGreyColor,
        title: Styles.appBarText(widget.fileName, context),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.url,
        key: _pdfViewerKey,
      ),
      //  SfPdfViewer.network(
      //   url,
      //   onDocumentLoaded: (PdfDocumentLoadedDetails details) {
      //     //print(details.document.pages.count);
      //   },
      //   onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
      //     AlertDialog(
      //       title: Text(details.error),
      //       content: Text(details.description),
      //       actions: <Widget>[
      //         ElevatedButton(
      //           child: const Text('تمام'),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // )
    );
  }
}
