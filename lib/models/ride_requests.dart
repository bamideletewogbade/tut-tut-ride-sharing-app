import 'package:cloud_firestore/cloud_firestore.dart';

class Ride {
  String rideId;
  String userId;
  String driverId;
  String pickupLocation;
  String dropoffLocation;
  DateTime requestTime;
  DateTime? pickupTime;
  DateTime? dropoffTime;
  double fare;
  String status; // e.g., pending, accepted, completed

  Ride({
    required this.rideId,
    required this.userId,
    required this.driverId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.requestTime,
    this.pickupTime,
    this.dropoffTime,
    required this.fare,
    required this.status,
  });

  factory Ride.fromMap(Map<String, dynamic> data) {
    return Ride(
      rideId: data['rideId'] ?? '',
      userId: data['userId'] ?? '',
      driverId: data['driverId'] ?? '',
      pickupLocation: data['pickupLocation'] ?? '',
      dropoffLocation: data['dropoffLocation'] ?? '',
      requestTime: (data['requestTime'] as Timestamp).toDate(),
      pickupTime: data['pickupTime'] != null ? (data['pickupTime'] as Timestamp).toDate() : null,
      dropoffTime: data['dropoffTime'] != null ? (data['dropoffTime'] as Timestamp).toDate() : null,
      fare: data['fare']?.toDouble() ?? 0.0,
      status: data['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rideId': rideId,
      'userId': userId,
      'driverId': driverId,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'requestTime': requestTime,
      'pickupTime': pickupTime,
      'dropoffTime': dropoffTime,
      'fare': fare,
      'status': status,
    };
  }
}
