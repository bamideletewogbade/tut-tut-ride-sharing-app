import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuk_tuk/models/payment.dart';
import 'firestore_service.dart';


class PaymentService {
  final FirestoreService _firestoreService = FirestoreService();
  final String collectionPath = 'payments';

  // Create or update a payment
  Future<void> setPayment(Payment payment) async {
    await _firestoreService.setData(
      collectionPath: collectionPath,
      docId: payment.paymentId,
      data: payment.toMap(),
    );
  }

  // Get a payment by ID
  Future<Payment> getPayment(String paymentId) async {
    DocumentSnapshot doc = await _firestoreService.getData(
      collectionPath: collectionPath,
      docId: paymentId,
    );
    return Payment.fromMap(doc.data() as Map<String, dynamic>);
  }

  // Update a payment
  Future<void> updatePayment(Payment payment) async {
    await _firestoreService.Payment(
      collectionPath: collectionPath,
      docId: payment.paymentId,
      data: payment.toMap(),
    );
  }

  // Delete a payment
  Future<void> deletePayment(String paymentId) async {
    await _firestoreService.Payment(
      collectionPath: collectionPath,
      docId: paymentId,
    );
  }
}
