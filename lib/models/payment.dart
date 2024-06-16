import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String paymentId;
  final String rideId;
  final String userId;
  final double amount;
  final DateTime timestamp;
  final String status;

  Payment({
    required this.paymentId,
    required this.rideId,
    required this.userId,
    required this.amount,
    required this.timestamp,
    required this.status,
  });

  // Method to convert PaymentModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'rideId': rideId,
      'userId': userId,
      'amount': amount,
      'timestamp': timestamp,
      'status': status,
    };
  }

  // Method to create a PaymentModel from a Map
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      paymentId: map['paymentId'],
      rideId: map['rideId'],
      userId: map['userId'],
      amount: map['amount'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      status: map['status'],
    );
  }
}
