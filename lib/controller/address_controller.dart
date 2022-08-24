import 'package:get/get.dart';
import 'package:printore/model/location/address.dart';
import 'package:printore/model/user/address.dart';
import 'package:printore/services/firestore_db.dart';

class AddressController extends GetxController {
  final address = <Address>[].obs;
  final userAddress = <UserAddress>[].obs;

  getAddress(String userId) {
    address.clear();
    address.bindStream(FirestoreDB().getAddress(userId));
    // userAddress.bindStream(FirestoreDB().getUserAddresses());
  }

  addNewAddress(){}
  addAddressDuringOrder(
      {required String receiverName,
      required String receiverPhoneNo,
      required String receiverGovernorate,
      required String receiverCity,
      required String address
      // required String receiverStreetName,
      // required String receiverBuildingNo,
      // required String receiverApartmentNo,
      }) {
    FirestoreDB().addAddressDuringOrder(
        receiverName: receiverName,
        receiverPhoneNo: receiverPhoneNo,
        receiverGovernorate: receiverGovernorate,
        receiverCity: receiverCity,
        address: address
        // receiverStreetName: receiverStreetName,
        // receiverBuildingNo: receiverBuildingNo,
        // receiverApartmentNo: receiverApartmentNo
        );
  }
}
