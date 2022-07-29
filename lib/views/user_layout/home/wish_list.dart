import 'package:flutter/material.dart';
import 'package:printore/views/auth/widgets/comming_soon.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return const CommingSoon();
  }
}
