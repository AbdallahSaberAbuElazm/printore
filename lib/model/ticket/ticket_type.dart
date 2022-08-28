import 'package:cloud_firestore/cloud_firestore.dart';

class TicketTypes {
  String? ticketType;
  TicketTypes({required this.ticketType});

  static TicketTypes fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return TicketTypes(ticketType: snapshot['ticketType']);
  }

  Map<String, dynamic> toMap() {
    return {'ticketType': ticketType};
  }
}
