import 'package:flutter/material.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/auth/widgets/text_form_field.dart';
import 'package:printore/model/authentication/firebase_auth.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Styles.logo(),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'هل نسيت كلمة المرور؟',
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text('ادخل بريدك الإلكتروني',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.right),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormFieldController(
                      isEnabled: true,
                      name: "البريد الإلكتروني",
                      type: TextInputType.emailAddress,
                      controller: _emailController),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FireAuth.resetPassword(
                            context: context,
                            email: _emailController.text.trim());
                      }
                    },
                    icon: const Icon(
                      Icons.email_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                    label: Text(
                      'إرسال',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    style: ElevatedButton.styleFrom(
                      shadowColor: MainColor.darkGreyColor,
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                  TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, 'login'),
                      child: Text('إلغاء',
                          style: Theme.of(context).textTheme.headline3,
                          textAlign: TextAlign.left)),
                ],
              ),
            ),
          ),
        ));
  }
}
