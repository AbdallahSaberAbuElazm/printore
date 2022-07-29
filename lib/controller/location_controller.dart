import 'package:get/get.dart';
import 'package:printore/model/location/city.dart';
import 'package:printore/model/location/country.dart';
import 'package:printore/model/location/governorate.dart';
import 'package:printore/services/firestore_db.dart';

class LocationController extends GetxController {
  final countryList = <Country>[].obs;
  final governorateList = <Governorate>[].obs;
  final cityList = <City>[].obs;

  @override
  void onInit() {
    countryList.bindStream(FirestoreDB().getCountries());
    governorateList.bindStream(FirestoreDB().getGovernorates());

    super.onInit();
  }

  updateCityList(String governorate) {
    cityList.bindStream(FirestoreDB().getCities(governorate));
    // update();
    notifyChildrens();
  }
}
