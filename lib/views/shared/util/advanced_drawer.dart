import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class AdvancedDrawerClass {
  static final advancedDrawerController = AdvancedDrawerController();
  static void handleMenuButtonPressed() {
    advancedDrawerController.showDrawer();
  }
}
