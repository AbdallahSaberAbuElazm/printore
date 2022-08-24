import 'package:flutter/material.dart';
import 'package:printore/views/auth/widgets/comming_soon.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/util/util.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
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
