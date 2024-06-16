import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/ride_request.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create
  Future<void> createRideRequest(RideRequest rideRequest) {
    return _db.collection('rideRequests').add(rideRequest.toMap());
  }

  // Read
  Future<RideRequest> getRideRequest(String id) async {
    DocumentSnapshot doc = await _db.collection('rideRequests').doc(id).get();
    return RideRequest.fromFirestore(doc);
  }

  // Update
  Future<void> updateRideRequest(RideRequest rideRequest) {
    return _db.collection('rideRequests').doc(rideRequest.id).update(rideRequest.toMap());
  }

  // Delete
  Future<void> deleteRideRequest(String id) {
    return _db.collection('rideRequests').doc(id).delete();
  }

  // Stream of ride requests
  Stream<List<RideRequest>> getRideRequests() {
    return _db.collection('rideRequests').snapshots().map((snapshot) => 
      snapshot.docs.map((doc) => RideRequest.fromFirestore(doc)).toList()
    );
  }
}
