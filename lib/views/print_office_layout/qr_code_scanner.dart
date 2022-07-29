import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printore/controller/order_controller.dart';
import 'package:printore/views/print_office_layout/po_home_page.dart';
import 'package:printore/views/print_office_layout/print_office_home.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/util/util.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:get/get.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrViewController;
  // Barcode? _barcode;
  OrderController orderController = Get.find();

  @override
  void dispose() {
    _qrViewController?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await _qrViewController!.pauseCamera();
    }
    _qrViewController!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
          child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            _buildQRView(),
            Positioned(bottom: 10, child: _builResult()),
            Positioned(
              child: _buildControllerButtons(),
              top: 10,
            )
          ],
        ),
      )),
    );
  }

  Widget _buildQRView() => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
          borderWidth: 10,
          borderLength: 20,
          borderRadius: 6,
          borderColor: MainColor.yellowColor,
        ),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );

  void onQRViewCreated(QRViewController qrViewController) {
    _qrViewController = qrViewController;

    _qrViewController!.scannedDataStream.listen((barcode) {
      _qrViewController?.dispose();
      Get.off(() => PrintOfficeHome(
          recentPage: const PrintOfficeHomePage(), selectedIndex: 0));
      int isDeliverd = orderController.checkQrCode(barcode.code.toString());
      Utils.snackBar(
        context: context,
        msg: (isDeliverd > 0)
            ? 'يتم تسليم ${orderController.noOfFileQrCode.value} ملفات'
            : 'لم يتم طباعة المستنات يرجي العوة الي طلبات الطباعة',
      );
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Widget _builResult() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(6)),
        child: const Text(
          'افحص',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      );

  Widget _buildControllerButtons() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              onPressed: () async {
                await _qrViewController!.toggleFlash();
              },
              icon: FutureBuilder<bool?>(
                future: _qrViewController?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(
                      snapshot.data! ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () async {
                await _qrViewController!.flipCamera();
              },
              icon: FutureBuilder(
                future: _qrViewController?.getCameraInfo(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return const Icon(
                      Icons.cameraswitch,
                      color: Colors.white,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      );
}
