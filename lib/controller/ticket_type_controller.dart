import 'package:get/get.dart';
import 'package:printore/model/ticket/ticket_type.dart';
import 'package:printore/services/firestore_db.dart';

class TicketTypeController extends GetxController {
  final list = <TicketTypes>[].obs;
  final ticketTypeChoosed = ''.obs;

  getTicketTypes() {
    list.bindStream(FirestoreDB().getTicketTypes());
    update();
  }

  uploadTicketType({required Map<String, dynamic> toMap}) {
    FirestoreDB().uploadTicketType(toMap: toMap);
  }

  updateTicketTypeChoosed({required String value}) {
    ticketTypeChoosed.value = value;
    update();
  }
}
