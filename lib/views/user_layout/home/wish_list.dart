import 'package:flutter/material.dart';
import 'package:printore/views/auth/widgets/comming_soon.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/util/util.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  Future<bool> _onWillPop() async {
    return (await Utils.showDialogOnWillPop(context: context)) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Directionality(
            textDirection: TextDirection.rtl, child: const CommingSoon()));
  }
}
