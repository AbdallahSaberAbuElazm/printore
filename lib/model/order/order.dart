import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String? orderId;
  String? printOfficeId;
  String? customerId;
  List<String>? cartIds;
  double? deliveryFee;
  double? total;
  double? subTotal;
  bool? isAccepted;
  bool? isCancelled;
  bool? isDeliverd;
  String? qrCode;
  String? createdAt;

  Order(
      {required this.orderId,
      required this.printOfficeId,
      required this.customerId,
      required this.cartIds,
      required this.deliveryFee,
      required this.total,
      required this.subTotal,
      required this.isAccepted,
      required this.isCancelled,
      required this.isDeliverd,
      required this.qrCode,
      required this.createdAt});

  static Order fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Order(
      orderId: snapshot.id,
      customerId: snapshot['customerId'],
      printOfficeId: snapshot['printOfficeId'],
      cartIds: List<String>.from(
        snapshot['cartIds'],
      ),
      deliveryFee: snapshot['deliveryFee'],
      total: snapshot['total'],
      subTotal: snapshot['subTotal'],
      isAccepted: snapshot['isAccepted'],
      isDeliverd: snapshot['isDeliverd'],
      isCancelled: snapshot['isCancelled'],
      qrCode: snapshot['qrCode'],
      createdAt: snapshot['createdAt'],
    );
  }

  Order copyWith({
    String? orderId,
    String? printOfficeId,
    String? customerId,
    List<String>? cartIds,
    double? deliveryFee,
    double? total,
    double? subTotal,
    bool? isAccepted,
    bool? isCancelled,
    bool? isDeliverd,
    String? qrCode,
    String? createdAt,
  }) {
    return Order(
        orderId: orderId ?? this.orderId,
        printOfficeId: printOfficeId ?? this.printOfficeId,
        customerId: customerId ?? this.customerId,
        cartIds: cartIds ?? this.cartIds,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        total: total ?? this.total,
        subTotal: subTotal ?? this.subTotal,
        isAccepted: isAccepted ?? this.isAccepted,
        isCancelled: isCancelled ?? this.isCancelled,
        isDeliverd: isDeliverd ?? this.isAccepted,
        qrCode: qrCode ?? this.qrCode,
        createdAt: createdAt ?? this.createdAt);
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'printOfficeId': printOfficeId,
      'cartIds': cartIds,
      'deliveryFee': deliveryFee,
      'total': total,
      'subTotal': subTotal,
      'isAccepted': isAccepted,
      'isCancelled': isCancelled,
      'isDeliverd': isDeliverd,
      'qrCode': qrCode,
      'createdAt': createdAt,
    };
  }
}
