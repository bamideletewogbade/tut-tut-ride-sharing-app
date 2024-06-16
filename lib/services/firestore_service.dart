import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> setData({required String collectionPath, required String docId, required Map<String, dynamic> data}) {
    return _db.collection(collectionPath).doc(docId).set(data);
  }

  Future<DocumentSnapshot> getData({required String collectionPath, required String docId}) {
    return _db.collection(collectionPath).doc(docId).get();
  }

  Future<void> updateData({required String collectionPath, required String docId, required Map<String, dynamic> data}) {
    return _db.collection(collectionPath).doc(docId).update(data);
  }

  Future<void> deleteData({required String collectionPath, required String docId}) {
    return _db.collection(collectionPath).doc(docId).delete();
  }
}
