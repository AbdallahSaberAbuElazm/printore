import 'package:flutter/material.dart';
import 'package:printore/views/auth/widgets/comming_soon.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';

class Offers extends StatefulWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return const CommingSoon();
  }
}
