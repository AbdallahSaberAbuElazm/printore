import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:printore/model/service_providers/print_office.dart';
import 'package:printore/model/service_providers/working_hours.dart';
import 'package:printore/model/user/user_service.dart';
import 'package:printore/services/firestore_db.dart';

class PrintOfficeController extends GetxController {
  final list = <PrintOffice>[].obs;
  final listWorkingHours = <WorkingHours>[].obs;
  final office = ''.obs;
  final governorate = ''.obs;
  final governorateIndex = 0.obs;
  final city = ''.obs;
  final cityIndex = 0.obs;
  final cityLatitude = 0.0.obs;
  final cityLangitude = 0.0.obs;
  final printOffice = <PrintOffice>[].obs;
  final searchOnPrintOffice = <UserService>[].obs;

  updateDay(String today) {
    office.value = today;
    update();
  }

  getPrintOffices(String governorate, String city) {
    list.clear();
    list.bindStream(
        FirestoreDB().getPrintOffices(governorate: governorate, city: city));
    update();
  }

  updateListOfPrintOffice({required PrintOffice printOffice}) {
    list.add(printOffice);
    update();
  }

  searchOnPrintOfficeUsingEmail({required String email}) {
    searchOnPrintOffice.clear();
    searchOnPrintOffice
        .bindStream(FirestoreDB().searchOnPrintOfficeUsingEmail(email: email));
    update();
  }

  getWorkingHours(
      {required String governorate,
      required String city,
      required String printOfficeId}) {
    listWorkingHours.clear();
    listWorkingHours.bindStream(FirestoreDB().getWorkingHours(
        governorate: governorate, city: city, printOfficeId: printOfficeId));
    update();
  }

  getSpecificPrintOffice({
    required String governorate,
    required String city,
    required String userId,
  }) {
    printOffice.bindStream(FirestoreDB().getSpecificPrintOffice(
        governorate: governorate, city: city, userId: userId));
    update();
  }

  updatePrintOffice(PrintOffice printOfficer) {
    printOffice.clear();
    printOffice.add(printOfficer);
    update();
  }

  addPrintOfficer(
      {required String governorate,
      required String city,
      required String printOfficerId,
      required PrintOffice printOffice}) {
    FirestoreDB().addPrintOfficer(
        printOffice: printOffice,
        governorate: governorate,
        city: city,
        printOfficerId: printOfficerId);
  }

  uploadSizeOption({
    required String governorate,
    required String city,
    required String printOfficerId,
    required Map<String, dynamic> map,
    required String paperSize,
  }) {
    FirestoreDB().addSizeOption(
        map: map,
        governorate: governorate,
        city: city,
        printOfficerId: printOfficerId,
        paperSize: paperSize);
  }

  uploadWrappingOption(
      {required String governorate,
      required String city,
      required String printOfficerId,
      required Map<String, dynamic> map,
      required String wrapping}) {
    FirestoreDB().addWrappingOption(
        map: map,
        governorate: governorate,
        city: city,
        printOfficerId: printOfficerId,
        wrapping: wrapping);
  }

  uploadWorkingHours(
      {required String governorate,
      required String city,
      required String printOfficerId,
      required Map<String, dynamic> map,
      required String workingHours}) {
    FirestoreDB().uploadWorkingHours(
        map: map,
        governorate: governorate,
        city: city,
        printOfficerId: printOfficerId,
        workingHours: workingHours);
  }

  makeUserAsPrintOfficer({required String printOfficeId, required bool value}) {
    FirestoreDB()
        .makeUserAsPrintOfficer(printOfficeId: printOfficeId, value: value);
  }

  updateGovernorate(String governorate, int index) {
    this.governorate.value = governorate;
    this.governorateIndex.value = index;
    update();
  }

  updateCity(String city, int index) {
    this.city.value = city;
    this.cityIndex.value = index;
    update();
  }

  updateCityLocation({required double latitude, required double langitude}) {
    this.cityLatitude.value = latitude;
    this.cityLangitude.value = langitude;
    update();
  }
}
