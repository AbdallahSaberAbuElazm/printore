import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static SharedPreferences? _sharedPreferences;

  static Future init() async =>
      _sharedPreferences = await SharedPreferences.getInstance();

  static Future setFirstOpen({required bool showHome}) async {
    return await _sharedPreferences!.setBool('showHome', showHome);
  }

  static bool? getFirstOpen() => _sharedPreferences!.getBool('showHome');

  static Future setUserInfo(
      {required String email,
      required String fName,
      required String lName,
      required String phoneNumber,
      required String avatarUrl,
      required String avatarName,
      required bool printingOfficer,
      required bool isAdmin}) async {
    await _sharedPreferences!.setString('email', email);
    await _sharedPreferences!.setString('fName', fName);
    await _sharedPreferences!.setString('lName', lName);
    await _sharedPreferences!.setString('avatarUrl', avatarUrl);
    await _sharedPreferences!.setString('photoName', avatarName);
    await _sharedPreferences!.setBool('printingOfficer', printingOfficer);
    await _sharedPreferences!.setBool('isAdmin', isAdmin);
    await _sharedPreferences!.setString('phoneNumber', phoneNumber);
  }

  //info about print office
  static Future setPrintOfficeInfo({
    required String printOfficeName,
    required String printOfficeAddress,
    required String printOfficeLocationGovernorate,
    required String printOfficeLocationCity,
  }) async {
    await _sharedPreferences!.setString('printOfficeName', printOfficeName);
    await _sharedPreferences!
        .setString('printOfficeAddress', printOfficeAddress);
    await _sharedPreferences!.setString(
        'printOfficeLocationGovernorate', printOfficeLocationGovernorate);
    await _sharedPreferences!
        .setString('printOfficeLocationCity', printOfficeLocationCity);
  }

  static String? getPrintOfficeName() {
    return _sharedPreferences!.getString('printOfficeName');
  }

  static String? getPrintOfficeAddress() {
    return _sharedPreferences!.getString('printOfficeAddress');
  }

  static String? printOfficeLocationGovernorate() {
    return _sharedPreferences!.getString('printOfficeLocationGovernorate');
  }

  static String? printOfficeLocationCity() {
    return _sharedPreferences!.getString('printOfficeLocationCity');
  }

  static Future setUserAvatar(
      {required String url, required String photoName}) async {
    await _sharedPreferences!.setString('avatarUrl', url);
    await _sharedPreferences!.setString('photoName', photoName);
  }

  static String? getUserAvatarUrl() {
    return _sharedPreferences!.getString('avatarUrl');
  }

  static String? getUserAvatarName() {
    return _sharedPreferences!.getString('photoName');
  }

  static String? getUserName() {
    return _sharedPreferences!.getString('fName').toString() +
        ' ' +
        _sharedPreferences!.getString('lName').toString() +
        ' ';
  }

  static String? getUserFirstName() {
    return _sharedPreferences!.getString('fName').toString();
  }

  static String? getUserLastName() {
    return _sharedPreferences!.getString('lName').toString();
  }

  static String? getUserPhoneNumber() {
    return _sharedPreferences!.getString('phoneNumber')!;
  }

  static String? getUseremail() => _sharedPreferences!.getString('email');
  static bool? getPrintingOfficer() =>
      _sharedPreferences!.getBool('printingOfficer');
  static bool? getIsAdmin() => _sharedPreferences!.getBool('isAdmin');

  static setWrapping({
    required List<String> wrappingDownloadUrl,
  }) async {
    await _sharedPreferences!.setStringList('wrapping', wrappingDownloadUrl);
  }

  static setLayouts({
    required List<String> layoutDownloadUrl,
  }) async {
    await _sharedPreferences!.setStringList('layouts', layoutDownloadUrl);
  }

  static List<String>? getOptionSizes() =>
      _sharedPreferences!.getStringList('sizes');

  static List<String>? getOptionWrapping() =>
      _sharedPreferences!.getStringList('wrapping');

  static List<String>? getOptionPaperTypes() =>
      _sharedPreferences!.getStringList('paperTypes');

  static List<String>? getOptionLayouts() =>
      _sharedPreferences!.getStringList('layouts');

  static Future removeDataForLogout() async {
    await _sharedPreferences!.remove('email');
    await _sharedPreferences!.remove('fName');
    await _sharedPreferences!.remove('lName');
    await _sharedPreferences!.remove('phoneNumber');
    await _sharedPreferences!.remove('avatarUrl');
    await _sharedPreferences!.remove('photoName');
    await _sharedPreferences!.remove('printingOfficer');
    await _sharedPreferences!.remove('isAdmin');
  }
}
