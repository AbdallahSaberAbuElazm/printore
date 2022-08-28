import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:printore/model/location/city.dart';
import 'package:printore/model/location/country.dart';
import 'package:printore/model/location/governorate.dart';
import 'package:printore/services/firestore_db.dart';

class LocationController extends GetxController {
  final countryList = <Country>[].obs;
  final governorateList = <Governorate>[].obs;
  final cityList = <City>[].obs;
  final List<LatLng> markerLocations = <LatLng>[].obs;

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

  updateMarkerLocations({required double latitude, required double longitude}) {
    markerLocations.add(LatLng(latitude, longitude));
    update();
  }

  clearMarkerLocaitonsList() {
    markerLocations.clear();
    update();
  }
}
