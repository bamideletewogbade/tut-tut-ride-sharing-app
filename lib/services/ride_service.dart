import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuk_tuk/models/ride_requests.dart';
import 'firestore_service.dart';

class RideService {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'rides';

  // Create or update a ride
  Future<void> setRide(Ride ride) async {
    await _firestoreService.setData(
      collectionPath: collectionPath,
      docId: ride.rideId,
      data: ride.toMap(),
    );
  }

  // Get a ride by ID
  Future<Ride> getRide(String rideId) async {
    DocumentSnapshot doc = await _firestoreService.getData(
      collectionPath: collectionPath,
      docId: rideId,
    );
    return Ride.fromMap(doc.data() as Map<String, dynamic>);
  }

  // Update a ride
  Future<void> updateRide(Ride ride) async {
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

Stream<List<Ride>> getNearbyRides(double latitude, double longitude, double radius) {
    // You might want to add geospatial queries here, for now, let's fetch all rides
    return _firestore.collection('rides').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Ride.fromFirestore(doc)).toList();
    });
  }

  Future<void> addRide(Ride ride) async {
    await _firestore.collection('rides').add({
      'userId': ride.userId,
      'driverId': ride.driverId,
      'pickupLocation': ride.pickupLocation,
      'dropoffLocation': ride.dropoffLocation,
      'requestTime': ride.requestTime,
      'fare': ride.fare,
      'status': ride.status,
    });
  }

//   // Fetch nearby rides using Firestore's geospatial querying
//   Stream<List<Ride>> getNearbyRides(double latitude, double longitude, double radius) {
//     final double lat = latitude;
//     final double lon = longitude;
//     final double radiusInKm = radius;

//     // Firestore uses degrees for geospatial queries, so we need to convert radius from km to degrees
//     final double radiusInDegrees = radiusInKm / 111.32;

//     return FirebaseFirestore.instance
//         .collection(collectionPath)
//         .where('pickupLocation', isGreaterThanOrEqualTo: GeoPoint(lat - radiusInDegrees, lon - radiusInDegrees))
//         .where('pickupLocation', isLessThanOrEqualTo: GeoPoint(lat + radiusInDegrees, lon + radiusInDegrees))
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => Ride.fromMap(doc.data() as Map<String, dynamic>))
//             .toList())
//         .map((rides) => rides.where((ride) {
//               final double distance = calculateDistance(lat, lon, ride.pickupLocation as double, ride.pickupLocation as double); // not sure about this line
//               return distance <= radiusInKm;
//             }).toList());
//   }



// double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//   const double p = 0.017453292519943295; // PI / 180
//   final double a = 0.5 - cos((lat2 - lat1) * p) / 2 +
//       cos(lat1 * p) * cos(lat2 * p) *
//           (1 - cos((lon2 - lon1) * p)) / 2;
//   return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
// }

}
