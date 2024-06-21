// ignore_for_file: implementation_imports

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_flutter_platform_interface/src/types/location.dart'; // Adjust this import based on your actual package structure
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
    return Ride.fromMap(doc.data() as Map<String, dynamic>, rideId);
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

  // Stream to get nearby rides within a radius from user's location
 Stream<List<Ride>> getNearbyRides(double latitude, double longitude, double radius) {
    var collectionRef = _firestore.collection('rides');

    // Create a GeoPoint for the user's location
    var center = GeoPoint(latitude, longitude);

    // Calculate the boundaries for the query
    var lowerLat = center.latitude - (radius / 111.12); // 1 degree of latitude ~= 111.12 km
    var lowerLon = center.longitude - (radius / (111.12 * cos(center.latitude * (pi / 180))));
    var upperLat = center.latitude + (radius / 111.12);
    var upperLon = center.longitude + (radius / (111.12 * cos(center.latitude * (pi / 180))));

    // Create a GeoPoint for the boundaries
    var lowerBound = GeoPoint(lowerLat, lowerLon);
    var upperBound = GeoPoint(upperLat, upperLon);

    // Perform a geospatial query to fetch rides within the specified radius
    return collectionRef
        .where('pickupLocation', isGreaterThan: lowerBound)
        .where('pickupLocation', isLessThan: upperBound)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Ride.fromFirestore(doc)).toList());
  }
  // Add a new ride
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
}
