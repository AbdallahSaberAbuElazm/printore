import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String userId;

  final String status;
  final String ticketType;
  final String message;

  Ticket({
    required this.ticketType,
    required this.message,
    required this.userId,
    required this.status,
  });

  static Ticket fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Ticket(
      ticketType: snapshot['ticketType'],
      message: snapshot['message'],
      status: snapshot['status'],
      userId: snapshot['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ticketType': ticketType,
      'message': message,
      'userId': userId,
      'status': status,
    };
  }
}
