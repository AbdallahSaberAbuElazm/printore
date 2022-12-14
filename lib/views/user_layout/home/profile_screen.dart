import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:printore/controller/user_controller.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/auth/widgets/password_form_field.dart';
import 'package:printore/views/auth/widgets/text_form_field.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/util/user_shared_preferences.dart';
import 'package:printore/views/shared/util/util.dart';
import 'package:printore/views/shared/widgets/upload_image_profile.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //update email
  final _currentEmailController = TextEditingController();
  final _updateEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();
  //update password
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final userController = Get.find<UserController>();
  final _formKeyUserInfo = GlobalKey<FormState>();
  final _formKeyUpdateEmail = GlobalKey<FormState>();
  final _formKeyUpdatePassword = GlobalKey<FormState>();

  @override
  void initState() {
    _fNameController.text =
        UserSharedPreferences.getUserFirstName()!.toString();
    _lNameController.text = UserSharedPreferences.getUserLastName()!.toString();
    _phoneController.text =
        UserSharedPreferences.getUserPhoneNumber()!.toString();
    _currentEmailController.text =
        UserSharedPreferences.getUseremail()!.toString();
    super.initState();
  }

  @override
  void dispose() {
    _updateEmailController.dispose();
    _currentEmailController.dispose();
    _signInPasswordController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    _fNameController.dispose();
    _lNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  OptionProvider? option;
  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await Utils.showDialogOnWillPop(context: context)) ?? false;
    }

    CheckInternetConnection.CheckUserConnection(context: context);
    option = Provider.of<OptionProvider>(context);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                    backgroundColor: Theme.of(context).backgroundColor,
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      title: Styles.appBarText('??????????', context),
                      centerTitle: true,
                      leading: IconButton(
                        onPressed: option!.handleMenuButtonPressed,
                        icon: ValueListenableBuilder<AdvancedDrawerValue>(
                          valueListenable: option!.advancedDrawerController,
                          builder: (_, value, __) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Icon(
                                value.visible ? Icons.clear : Icons.menu,
                                key: ValueKey<bool>(value.visible),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    body: SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Column(children: [
                        Stack(children: [
                          Image.asset(
                            'assets/images/profileBackground.png',
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2.7,
                            fit: BoxFit.fill,
                            //color: const Color(0xffe5e5e5),
                          ),
                          Positioned(
                              top: MediaQuery.of(context).size.height / 9.5,
                              left: 30,
                              right: 30,
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.bottomStart,
                                    children: [
                                      CircleAvatar(
                                        radius: 60,
                                        backgroundColor: MainColor.yellowColor,
                                        backgroundImage: (UserSharedPreferences
                                                    .getUserAvatarUrl() !=
                                                null)
                                            ? NetworkImage(UserSharedPreferences
                                                .getUserAvatarUrl()!)
                                            : Image.asset(
                                                    'assets/images/logo.png')
                                                as ImageProvider,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          UploadImageProfile.uploadImageProfile(
                                                  context: context)
                                              .then((value) {
                                            if (value.isNotEmpty) {
                                              setState(() {
                                                UserSharedPreferences
                                                    .setUserAvatar(
                                                        url: value['url'],
                                                        photoName: basename(
                                                            value[
                                                                'avatarName']));
                                              });
                                            }
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey[300],
                                          child: Icon(
                                            Icons.image,
                                            color: MainColor.darkGreyColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: Text(
                                      UserSharedPreferences.getUserName()
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 24.0),
                                    ),
                                  )
                                ],
                              )),
                        ]),
                        Transform.translate(
                          offset: const Offset(0, 20),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 1.9,
                            child: ListView(
                              padding: const EdgeInsets.only(bottom: 30),
                              shrinkWrap: true,
                              children: [
                                _userInfo(
                                    title: '?????????????? ???????????? ????????????',
                                    suffixIcon: Icons.person,
                                    widget: _expandedUserInfo(context: context),
                                    context: context),
                                _userInfo(
                                    title: '?????????? ???????????? ????????????????????',
                                    suffixIcon: Icons.email,
                                    widget:
                                        _expandedUpdateEmail(context: context),
                                    context: context),
                                _userInfo(
                                    title: '?????????? ???????? ????????????',
                                    suffixIcon: Icons.person,
                                    widget: _expandedUpdatePassword(
                                        context: context),
                                    context: context),
                              ],
                            ),
                          ),
                        )
                      ]),
                    )))));
  }

  Widget _userInfo(
      {required String title,
      required IconData suffixIcon,
      required Widget widget,
      required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 6, top: 6),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        color: Colors.white70.withOpacity(0.5),
      ),
      child: ExpansionTile(
        // backgroundColor: Colors.white70.withOpacity(0.5),
        iconColor: MainColor.darkGreyColor,
        leading: Icon(
          suffixIcon,
          color: MainColor.darkGreyColor,
          size: 30,
        ),
        title: Text(title, style: Theme.of(context).textTheme.headline4),
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: widget,
          ),
        ],
      ),
    );
  }

  Widget _expandedUserInfo({required BuildContext context}) {
    return Form(
      key: _formKeyUserInfo,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.7,
                child: TextFormFieldController(
                    controller: _fNameController,
                    isEnabled: true,
                    name: '?????????? ??????????',
                    type: TextInputType.name),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.7,
                child: TextFormFieldController(
                    controller: _lNameController,
                    isEnabled: true,
                    name: '?????????? ????????????',
                    type: TextInputType.name),
              ),
            ],
          ),
          TextFormFieldController(
              controller: _phoneController,
              isEnabled: true,
              name: '?????? ????????????',
              type: TextInputType.phone),
          _btnUpdateData(
              context: context,
              onTap: () {
                if (_formKeyUserInfo.currentState!.validate()) {
                  userController.updateUserInfo(
                      fName: _fNameController.text,
                      lName: _lNameController.text,
                      phoneNum: _phoneController.text);
                  setState(() {
                    _fNameController.text =
                        UserSharedPreferences.getUserFirstName().toString();
                    _lNameController.text =
                        UserSharedPreferences.getUserLastName().toString();
                    _phoneController.text =
                        UserSharedPreferences.getUserPhoneNumber().toString();
                  });
                }
              }),
        ],
      ),
    );
  }

  Widget _expandedUpdateEmail({required BuildContext context}) {
    return Form(
      key: _formKeyUpdateEmail,
      child: Column(children: [
        TextFormFieldController(
            name: '???????????? ???????????????????? ????????????',
            type: TextInputType.emailAddress,
            controller: _currentEmailController,
            isEnabled: false),
        TextFormFieldController(
            name: '???????????? ???????????????????? ????????????',
            type: TextInputType.emailAddress,
            controller: _updateEmailController,
            isEnabled: true),
        PasswordFormField(
          controller: _signInPasswordController,
          hintText: '???????? ????????????',
        ),
        _btnUpdateData(
            context: context,
            onTap: () {
              if (_formKeyUpdateEmail.currentState!.validate()) {
                userController.updateEmail(
                    newEmail: _updateEmailController.text,
                    password: _signInPasswordController.text);
              }
            }),
      ]),
    );
  }

  Widget _expandedUpdatePassword({required BuildContext context}) {
    return Form(
      key: _formKeyUpdatePassword,
      child: Column(
        children: [
          PasswordFormField(
            controller: _currentPasswordController,
            hintText: '???????? ???????????? ??????????????',
          ),
          PasswordFormField(
            controller: _newPasswordController,
            hintText: '???????? ???????????? ??????????????',
          ),
          PasswordFormField(
            controller: _confirmNewPasswordController,
            hintText: '?????????? ???????? ????????????',
          ),
          _btnUpdateData(
              context: context,
              onTap: () {
                if (_formKeyUpdatePassword.currentState!.validate()) {
                  userController.changePassword(
                      currentPassword: _currentPasswordController.text,
                      newPassword: _newPasswordController.text,
                      context: context);
                  _currentEmailController.text = '';
                  _newPasswordController.text = '';
                  _confirmNewPasswordController.text = '';
                }
              }),
        ],
      ),
    );
  }

  Widget _btnUpdateData({required BuildContext context, dynamic onTap}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 15),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3.5,
              height: 40,
              decoration: BoxDecoration(
                  color: MainColor.darkGreyColor,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 8,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ]),
              child: Center(
                child: Text(
                  '??????????',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
