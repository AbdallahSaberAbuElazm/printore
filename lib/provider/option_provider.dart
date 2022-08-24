import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:printore/views/user_layout/home/home_page.dart';

class OptionProvider with ChangeNotifier {
  String sizeSelected = 'A5';
  int sizeIndex = 1;
  String paperTypeSelected = '70 جم';
  String layoutSelected = 'قائم';
  String wrappingSelected = 'بدون تغليف';
  String sideSelected = 'وجه واحد';
  String colorSelected = 'أبيض-أسود';

  double percentageFileProgress = 0.0;
  double bytesOfFile = 0.0;
  Widget recentPage = const HomePage();

  final advancedDrawerController = AdvancedDrawerController();

  void handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    advancedDrawerController.value = AdvancedDrawerValue.visible();
    advancedDrawerController.showDrawer();
  }

  updateRecentPage(Widget page) {
    recentPage = page;
    notifyListeners();
  }

  updatePercentageFileProgress(double percentage) {
    percentageFileProgress = percentage;
    notifyListeners();
  }

  updateBytesOfFiles(double bytesOfFile) {
    bytesOfFile = bytesOfFile;
    notifyListeners();
  }

  updateSizeSelected(String size) {
    sizeSelected = size;
    notifyListeners();
  }

  updateColor(String colorName) {
    colorSelected = colorName;
    notifyListeners();
  }

  updateSideSelected(String side) {
    sideSelected = side;
    notifyListeners();
  }

  updateSizedIndex(int index) {
    sizeIndex = index;
    notifyListeners();
  }

  updateLayoutSelected(String layout) {
    layoutSelected = layout;
    notifyListeners();
  }

  updatePaperTypeSelected(String paperType) {
    paperTypeSelected = paperType;
    notifyListeners();
  }

  updateWrappingSelected(String wrapping) {
    wrappingSelected = wrapping;
    notifyListeners();
  }

  void restOptions() {
    sizeSelected = 'A4';
    paperTypeSelected = 'عادي';
    layoutSelected = 'تلقائي';
    // sideSelected = 'وجه واحد';
    wrappingSelected = 'بدون تغليف';
    notifyListeners();
  }
}
