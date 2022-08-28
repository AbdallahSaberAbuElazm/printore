import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:printore/controller/paper_type_controller.dart';
import 'package:printore/controller/size_controller.dart';
import 'package:printore/model/authentication/firebase_auth.dart';
import 'package:printore/model/cart/cart.dart';
import 'package:printore/model/frequently_questions/frequently_asked_questions.dart';
import 'package:printore/model/location/address.dart';
import 'package:printore/model/location/city.dart';
import 'package:printore/model/location/country.dart';
import 'package:printore/model/location/governorate.dart';
import 'package:printore/model/order/order.dart';
import 'package:printore/model/product/option/layout.dart';
import 'package:printore/model/product/option/paper_price.dart';
import 'package:printore/model/product/option/paper_type.dart';
import 'package:printore/model/product/option/side.dart';
import 'package:printore/model/product/option/size.dart';
import 'package:printore/model/product/option/wrapping.dart';
import 'package:printore/model/review/review.dart';
import 'package:printore/model/service_providers/print_office.dart';
import 'package:printore/model/service_providers/working_hours.dart';
import 'package:printore/model/ticket/ticket_type.dart';
import 'package:printore/model/ticket/ticket.dart';
import 'package:printore/model/user/user_service.dart';

class FirestoreDB {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  SizeController sizeController = SizeController();
  PaperTypeController paperTypeController = PaperTypeController();
  User? user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getSpecificUser(
      {required String userId}) async {
    return await _firebaseFirestore.collection('users').doc(userId).get();
  }

  updateEmail({required String newEmail, required String password}) async {
    user!.updateEmail(newEmail).then((value) {
      user!.sendEmailVerification();
      _firebaseFirestore
          .collection('users')
          .doc(user!.uid)
          .update({'email': newEmail});
    });
    // user!.reauthenticateWithCredential(EmailAuthProvider.credentialWithLink(
    //     email: UserSharedPreferences.getUseremail().toString(),
    //     emailLink: newEmail));
  }

  updateUserInfo(
      {required String fName,
      required String lName,
      required String phoneNum}) async {
    await _firebaseFirestore.collection('users').doc(user!.uid).update({
      'first_name': fName,
      'last_name': lName,
      'mobile': phoneNum
    }).then((value) async {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      FireAuth.getUserInfo(user: user!, result: result);
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSpecificCart(
      {required String cartId, required String userId}) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(userId.toString().trimLeft().trimRight())
        .collection('carts')
        .doc(cartId)
        .get();
  }

  updateStatusOrder({required String orderId, required bool value}) async {
    await _firebaseFirestore
        .collection('users')
        .doc(user!.uid.toString().trimLeft().trimRight())
        .collection('checkout')
        .doc(orderId)
        .update({'isAccepted': value});
  }

  updateStatusCart(
      {required String userId,
      required String cartId,
      required bool value}) async {
    await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('carts')
        .doc(cartId)
        .update({'finished': value});
  }

  //get size of paper
  Stream<List<Size>> getSizes() {
    return _firebaseFirestore.collection('sizes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Size.fromSnapShot(doc)).toList());
  }

  //get list of paper type
  Stream<List<PaperType>> getPaperTypes() {
    return _firebaseFirestore.collection('paperTypes').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => PaperType.fromSnapShot(doc)).toList());
  }

  //get list of side
  Stream<List<Side>> getSide() {
    return _firebaseFirestore.collection('sides').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Side.fromSnapShot(doc)).toList());
  }

  //get list of wrapping
  Stream<List<Wrapping>> getWrapping() {
    return _firebaseFirestore.collection('wrapping').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Wrapping.fromSnapShot(doc)).toList());
  }

  //get list of layout
  Stream<List<Layout>> getLayouts() {
    return _firebaseFirestore.collection('layouts').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Layout.fromSnapShot(doc)).toList());
  }

  // get all countries
  Stream<List<Country>> getCountries() {
    return _firebaseFirestore.collection('locations').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Country.fromSnapShot(doc)).toList());
  }

  Stream<List<Governorate>> getGovernorates() {
    return _firebaseFirestore
        .collection('locations')
        .doc('Egypt')
        .collection('governorates')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Governorate.fromSnapShot(doc)).toList());
  }

// get cities
  Stream<List<City>> getCities(String governorate) {
    return _firebaseFirestore
        .collection('locations')
        .doc('Egypt')
        .collection('governorates')
        .doc(governorate)
        .collection('cities')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => City.fromSnapShot(doc)).toList());
  }

  // get print offices
  Stream<List<PrintOffice>> getPrintOffices(
      {required String governorate, required String city}) {
    return _firebaseFirestore
        .collection('serviceProvidersPrintOffices')
        .doc(governorate.toString().trimRight().trimLeft())
        .collection(city.toString().trimRight().trimLeft())
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => PrintOffice.fromSnapShot(doc)).toList());
  }

  Stream<List<UserService>> searchOnPrintOfficeUsingEmail(
      {required String email}) {
    return _firebaseFirestore
        .collection('users')
        .where('email', isEqualTo: email)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserService.fromDocumentSnapshot(doc))
            .toList());
  }

  Stream<List<WorkingHours>> getWorkingHours(
      {required String governorate,
      required String city,
      required String printOfficeId}) {
    return _firebaseFirestore
        .collection('serviceProvidersPrintOffices')
        .doc(governorate)
        .collection(city)
        .doc(printOfficeId.trimLeft().trimRight())
        .collection('workingHours')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkingHours.fromDocumentSnapshot(doc))
            .toList());
  }

  Stream<List<PrintOffice>> getSpecificPrintOffice({
    required String governorate,
    required String city,
    required String userId,
  }) {
    return _firebaseFirestore
        .collection('serviceProvidersPrintOffices')
        .doc(governorate)
        .collection(city)
        .where('printOfficeId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => PrintOffice.fromSnapShot(doc)).toList());
  }

  addPrintOfficer(
      {required String governorate,
      required String city,
      required String printOfficerId,
      required PrintOffice printOffice}) async {
    await _firebaseFirestore
        .collection('serviceProvidersPrintOffices')
        .doc(governorate)
        .collection(city)
        .doc(printOfficerId.toString().trimLeft().trimRight())
        .set(printOffice.toMap());
    await _firebaseFirestore
        .collection('addresses')
        .doc(printOfficerId.toString().trimLeft().trimRight())
        .set({
      'cityName': city,
      'governorateName': governorate,
      'countryName': 'egypt',
      'userId': printOfficerId.toString().trimLeft().trimRight()
    });
  }

  addSizeOption({
    required String governorate,
    required String city,
    required String printOfficerId,
    required Map<String, dynamic> map,
    required String paperSize,
  }) {
    _firebaseFirestore
        .collection('serviceProvidersPrintOffices')
        .doc(governorate)
        .collection(city)
        .doc(printOfficerId.toString().trimLeft().trimRight())
        .collection('sizes')
        .doc(paperSize.toString().trimLeft().trimRight())
        .set(map);
  }

  uploadWorkingHours(
      {required String governorate,
      required String city,
      required String printOfficerId,
      required Map<String, dynamic> map,
      required String workingHours}) {
    _firebaseFirestore
        .collection('serviceProvidersPrintOffices')
        .doc(governorate)
        .collection(city)
        .doc(printOfficerId.toString().trimLeft().trimRight())
        .collection('workingHours')
        .doc(workingHours.toString().trimLeft().trimRight())
        .set(map);
  }

  addWrappingOption(
      {required String governorate,
      required String city,
      required String printOfficerId,
      required Map<String, dynamic> map,
      required String wrapping}) {
    _firebaseFirestore
        .collection('serviceProvidersPrintOffices')
        .doc(governorate)
        .collection(city)
        .doc(printOfficerId.toString().trimLeft().trimRight())
        .collection('wrapping')
        .doc(wrapping.toString().trimLeft().trimRight())
        .set(map);
  }

  makeUserAsPrintOfficer(
      {required String printOfficeId, required bool value}) async {
    await _firebaseFirestore
        .collection('users')
        .doc(printOfficeId.toString().trimLeft().trimRight())
        .update({'printingOfficer': value});
  }

  Stream<List<Address>> getAddress(String userId) {
    return _firebaseFirestore
        .collection('addresses')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Address.fromDocumentSnapshot(doc))
            .toList());
  }

  Stream<List<Address>> getUserAddresses() {
    return _firebaseFirestore
        .collection('users')
        .doc(user!.uid)
        .collection('addresses')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Address.fromDocumentSnapshot(doc))
            .toList());
  }

  addAddressDuringOrder(
      {required String receiverName,
      required String receiverPhoneNo,
      required String receiverGovernorate,
      required String receiverCity,
      required String address}) async {
    await _firebaseFirestore
        .collection('users')
        .doc(user!.uid)
        .collection('addresses')
        .add({
      'receiverName': receiverName,
      'receiverPhoneNo': receiverPhoneNo,
      'receiverGovernorate': receiverGovernorate,
      'receiverCity': receiverCity,
      'address': address
    });
  }

  updateAddress({
    required String receiverName,
    required String receiverPhoneNo,
    required String receiverGovernorate,
    required String receiverCity,
    required String receiverStreetName,
    required String receiverBuildingNo,
    required String receiverApartmentNo,
    required String receiverAddressId,
  }) {
    _firebaseFirestore
        .collection('users')
        .doc(user!.uid)
        .collection('addresses')
        .doc(receiverAddressId)
        .update({
      'receiverName': receiverName,
      'receiverPhoneNo': receiverPhoneNo,
      'receiverGovernorate': receiverGovernorate,
      'receiverCity': receiverCity,
      'receiverStreetName': receiverStreetName,
      'receiverBuildingNo': receiverBuildingNo,
      'receiverApartmentNo': receiverApartmentNo
    });
  }

  //get frequently question
  Stream<List<FrequentlyAskedQuestions>> getFrequenltyQuestions() {
    return _firebaseFirestore
        .collection('frequentlyAskedQuestions')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FrequentlyAskedQuestions.fromSnapShot(doc))
            .toList());
  }

  //get Cart
  Stream<List<Cart>> getCart() {
    return _firebaseFirestore
        .collection('users')
        .doc(user!.uid)
        .collection('carts')
        .where('ordered', isEqualTo: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Cart.fromSnapShot(doc)).toList());
  }

  Stream<List<Order>> getPrintOfficerOrders() {
    return _firebaseFirestore
        .collection('users')
        .doc(user!.uid.toString().trimLeft().trimRight())
        .collection('checkout')
        .where('isAccepted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Order.fromDocumentSnapshot(doc))
            .toList());
  }

  Stream<List<Order>> getPrintOfficerCompletedOrders() {
    return _firebaseFirestore
        .collection('users')
        .doc(user!.uid.toString().trimLeft().trimRight())
        .collection('checkout')
        .where('isAccepted', isEqualTo: true)
        .where('isDeliverd', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Order.fromDocumentSnapshot(doc))
            .toList());
  }

  Stream<List<Order>> getUserOrders() {
    return _firebaseFirestore
        .collection('users')
        .doc(user!.uid.toString().trimLeft().trimRight())
        .collection('orders')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Order.fromDocumentSnapshot(doc))
            .toList());
  }

  setOrders({required Order order, required String printOfficeId}) async {
    final officeId = printOfficeId;
    await _firebaseFirestore
        .collection('users')
        .doc(officeId.toString().trimLeft().trimRight())
        .collection('checkout')
        .add(order.toMap());
  }

  updateCartOrdered({required String cartId}) async {
    await _firebaseFirestore
        .collection('users')
        .doc(user!.uid.toString().trimLeft().trimRight())
        .collection('carts')
        .doc(cartId)
        .update({'ordered': true});
  }

  Stream<List<Review>> getPrintOfficeReviews(
      {required String governorate,
      required String city,
      required String printOfficeName}) {
    return _firebaseFirestore
        .collection('serviceProvidersPrintOffices')
        .doc(governorate)
        .collection(city)
        .doc(printOfficeName)
        .collection('reviews')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Review.fromSnapShot(doc)).toList());
  }

  updateDeliverdOrders(
      {required String barcode,
      required String orderId,
      required String customerId,
      required Map<String, dynamic> toMap}) async {
    await _firebaseFirestore
        .collection('users')
        .doc(user!.uid.toString().trimLeft().trimRight())
        .collection('checkout')
        .doc(orderId)
        .update({'isDeliverd': true});
    await _firebaseFirestore
        .collection('users')
        .doc(customerId.toString().trimLeft().trimRight())
        .collection('cart')
        .where('ordered', isEqualTo: true)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((doc) => {doc.reference.delete()})
            });
    await _firebaseFirestore
        .collection('users')
        .doc(customerId.toString().trimLeft().trimRight())
        .collection('orders')
        .add(toMap);
  }

  Stream<List<PaperPrice>> getPaperPrice(
      {required String paperSize,
      required String paperType,
      required String paperColor}) {
    return _firebaseFirestore
        .collection('paperPrice')
        .doc(paperSize.toString())
        .collection(paperType.toString())
        .where('paperColor', isEqualTo: paperColor)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PaperPrice.fromDocumentSnapshot(doc))
            .toList());
  }

  uploadReview({required Map<String, dynamic> toMap}) async {
    await _firebaseFirestore.collection('reviews').add(toMap);
  }

  sendTicket({required Map<String, dynamic> toMap}) async {
    await _firebaseFirestore.collection('tickets').add(toMap);
  }

  Stream<List<Ticket>> getTickets() {
    return _firebaseFirestore.collection('tickets').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Ticket.fromDocumentSnapshot(doc))
            .toList());
  }

  Stream<List<TicketTypes>> getTicketTypes() {
    return _firebaseFirestore.collection('ticketTypes').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => TicketTypes.fromDocumentSnapshot(doc))
            .toList());
  }

  uploadTicketType({required Map<String, dynamic> toMap}) async {
    await _firebaseFirestore.collection('ticketTypes').add(toMap);
  }

  // Stream<List<Review>> getAllReviews() {
  //    return _firebaseFirestore
  //       .collection('printOffices')
  //       .doc()
  //       .collection()
  //       .doc()
  //       .collection('reviews')
  //       .snapshots()
  //       .map((snapshot) =>
  //           snapshot.docs.map((doc) => Review.fromSnapShot(doc)).toList());
  // }
}
