import 'package:cloud_firestore/cloud_firestore.dart';

class Ride {
  final String rideId;
  final String userId;
  final String driverId;
  final GeoPoint pickupLocation;
  final GeoPoint dropoffLocation;
  final DateTime requestTime;
  final double fare;
  final String status;

  Ride({
    required this.rideId,
    required this.userId,
    required this.driverId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.requestTime,
    required this.fare,
    required this.status,
  });

  factory Ride.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ride(
      rideId: doc.id,
      userId: data['userId'],
      driverId: data['driverId'],
      pickupLocation: data['pickupLocation'],
      dropoffLocation: data['dropoffLocation'],
      requestTime: (data['requestTime'] as Timestamp).toDate(),
      fare: data['fare'].toDouble(),
      status: data['status'],
    );
  }

  factory Ride.fromMap(Map<String, dynamic> data, String id) {
    return Ride(
      rideId: id,
      userId: data['userId'],
      driverId: data['driverId'],
      pickupLocation: data['pickupLocation'],
      dropoffLocation: data['dropoffLocation'],
      requestTime: (data['requestTime'] as Timestamp).toDate(),
      fare: data['fare'].toDouble(),
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'driverId': driverId,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'requestTime': requestTime,
      'fare': fare,
      'status': status,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'driverId': driverId,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'requestTime': requestTime,
      'fare': fare,
      'status': status,
    };
  }
}
