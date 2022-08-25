import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/model/authentication/firebase_auth.dart';
import 'package:printore/views/auth/verify_email_page.dart';
import 'package:printore/views/auth/widgets/password_form_field.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/auth/widgets/text_form_field.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _checkValue = false;
  bool _switchVal = false;

  final _emailController = TextEditingController();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _fNameController.dispose();
    _lNameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(right: 30, left: 30),
              child: ListView(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    // ignore: sized_box_for_whitespace
                    Styles.logo(width: 70, height: 60),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      'تسجيل حساب جديد',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.headline1,
                    ),

                    TextFormFieldController(
                        isEnabled: true,
                        name: 'الاسم الأول',
                        type: TextInputType.name,
                        controller: _fNameController),
                    const SizedBox(
                      height: 18,
                    ),
                    TextFormFieldController(
                        isEnabled: true,
                        name: 'الاسم الأخير',
                        type: TextInputType.name,
                        controller: _lNameController),
                    const SizedBox(height: 18),
                    TextFormFieldController(
                        isEnabled: true,
                        name: "البريد الإلكتروني",
                        type: TextInputType.emailAddress,
                        controller: _emailController),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'هل أنت طالب جامعي',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Row(
                          children: [
                            Text(
                              'لا',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Switch(
                              activeColor: MainColor.darkGreyColor,
                              onChanged: (value) {
                                setState(() {
                                  _switchVal = value;
                                });
                              },
                              value: _switchVal,
                            ),
                            Text(
                              'نعم',
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        )
                      ],
                    ),

                    TextFormFieldController(
                        isEnabled: true,
                        name: "رقم الجوال",
                        type: TextInputType.phone,
                        controller: _phoneController),
                    const SizedBox(height: 18),
                    PasswordFormField(
                      controller: _passwordController,
                      hintText: 'كلمة المرور',
                    ),
                    const SizedBox(height: 18),
                    PasswordFormField(
                        controller: _confirmPasswordController,
                        hintText: 'تأكيد كلمة المرور'),
                    Row(
                      children: [
                        Checkbox(
                            activeColor: MainColor.darkGreyColor,
                            hoverColor: MainColor.darkGreyColor,
                            focusColor: MainColor.darkGreyColor,
                            value: _checkValue,
                            onChanged: (value) {
                              setState(() {
                                _checkValue = value!;
                              });
                            }),
                        Row(
                          children: [
                            Text(
                              'أوافق علي',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'الشروط والأحكام',
                                style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    color: MainColor.darkGreyColor),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Styles.loginButton(
                            context,
                            'إنشاء حساب ',
                            (_checkValue)
                                ? () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (_passwordController.text ==
                                          _confirmPasswordController.text) {
                                        FireAuth.registerUsingEmailPassword(
                                          context: context,
                                          firstName:
                                              _fNameController.text.trim(),
                                          lastName:
                                              _lNameController.text.trim(),
                                          email: _emailController.text,
                                          universityStudent: _switchVal,
                                          mobile: _phoneController.text.trim(),
                                          password: _passwordController.text,
                                        ).then((value) => Get.off(
                                            () => const VerifyEmailPage()));
                                      }
                                    }
                                  }
                                : null),
                        Styles.registerButton(context, 'تسجيل دخول', () {
                          Navigator.pushNamed(context, 'login');
                        }),
                      ],
                    ),
                  ]),
            ),
          ),
        ));
  }
}
