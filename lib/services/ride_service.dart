import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';


class RideService {
  final FirestoreService _firestoreService = FirestoreService();
  final String collectionPath = 'rides';

  // Create or update a ride
  Future<void> setRide(RideModel ride) async {
    await _firestoreService.setData(
      collectionPath: collectionPath,
      docId: ride.rideId,
      data: ride.toMap(),
    );
  }

  // Get a ride by ID
  Future<RideModel> getRide(String rideId) async {
    DocumentSnapshot doc = await _firestoreService.getData(
      collectionPath: collectionPath,
      docId: rideId,
    );
    return RideModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  // Update a ride
  Future<void> updateRide(RideModel ride) async {
    await _firestoreService.updateData(
      collectionPath: collectionPath,
      docId: ride.rideId,
      data: ride.toMap(),
    );
  }

  // Delete a ride
  Future<void> deleteRide(String rideId) async {
    await _firestoreService.deleteData(
      collectionPath: collectionPath,
      docId: rideId,
    );
  }
}
