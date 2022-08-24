import 'package:flutter/material.dart';
import 'package:printore/views/auth/widgets/comming_soon.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';

class Discount extends StatefulWidget {
  const Discount({Key? key}) : super(key: key);

  @override
  State<Discount> createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return const CommingSoon();
  }
}
