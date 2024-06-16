import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuk_tuk/models/user.dart';
import 'package:tuk_tuk/services/firestore_service.dart';


class UserService {
  final FirestoreService _firestoreService = FirestoreService();
  final String collectionPath = 'users';

  // Create or update a user
  Future<void> setUser(User user) async {
    await _firestoreService.setData(
      collectionPath: collectionPath,
      docId: user.uid,
      data: user.toMap(),
    );
  }

  // Get a user by ID
  Future<User> getUser(String uid) async {
    DocumentSnapshot doc = await _firestoreService.getData(
      collectionPath: collectionPath,
      docId: uid,
    );
    return User.fromMap(doc.data() as Map<String, dynamic>);
  }

  // Update a user
  Future<void> updateUser(User user) async {
    await _firestoreService.updateData(
      collectionPath: collectionPath,
      docId: user.uid,
      data: user.toMap(),
    );
  }

  // Delete a user
  Future<void> deleteUser(String uid) async {
    await _firestoreService.deleteData(
      collectionPath: collectionPath,
      docId: uid,
    );
  }
}
