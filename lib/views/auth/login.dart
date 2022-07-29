import 'package:flutter/material.dart';
import 'package:printore/model/authentication/firebase_auth.dart';
import 'package:printore/views/auth/forgot_password_page.dart';
import 'package:printore/views/auth/widgets/password_form_field.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/auth/widgets/text_form_field.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Padding(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Form(
              key: _formKey,
              child: ListView(children: [
                const SizedBox(
                  height: 70,
                ),
                Styles.logo(),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'مرحبا بك من جديد',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text("من فضلك سجل دخولك للإستمرار",
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
                const SizedBox(height: 30),
                PasswordFormField(
                    controller: _passwordController, hintText: 'كلمة المرور'),
                const SizedBox(height: 25),
                Center(
                    child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage())),
                        child: Text('هل نسبت كلمة المرور؟',
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.left))),
                const SizedBox(
                  height: 35,
                ),
                Center(
                  child: Styles.loginButton(context, 'تسجيل دخول', () async {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Center(
                              child: CircularProgressIndicator(
                                  color: MainColor.darkGreyColor)));

                      await FireAuth.signInUsingEmailPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                          context: context);
                    }
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: Styles.registerButton(context, 'إنشاء حساب', () {
                  Navigator.pushNamed(context, 'register');
                })),
              ]),
            ),
          ),
        ));
  }
}
