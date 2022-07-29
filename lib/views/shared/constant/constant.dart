import 'package:firebase_auth/firebase_auth.dart';

class Constant {
  static User? user = FirebaseAuth.instance.currentUser;
}
