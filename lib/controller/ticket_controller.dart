import 'package:get/get.dart';
import 'package:printore/model/ticket/ticket.dart';
import 'package:printore/services/firestore_db.dart';

class TicketController extends GetxController {
  final list = <Ticket>[].obs;

  sendTicket(Map<String, dynamic> toMap) {
    FirestoreDB().sendTicket(toMap: toMap);
  }

  getTickets() {
    list.bindStream(FirestoreDB().getTickets());
    update();
  }
}
