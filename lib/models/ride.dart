import 'package:cloud_firestore/cloud_firestore.dart';

class Ride {
  final String rideId;
  final String passengerId;
  final String driverId;
  final DateTime requestTime;
  final DateTime? startTime;
  final DateTime? endTime;
  final double fare;
  final String status;
  final GeoPoint pickupLocation;
  final GeoPoint dropoffLocation;

  Ride({
    required this.rideId,
    required this.passengerId,
    required this.driverId,
    required this.requestTime,
    this.startTime,
    this.endTime,
    required this.fare,
    required this.status,
    required this.pickupLocation,
    required this.dropoffLocation,
  });

  // Method to convert RideModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'rideId': rideId,
      'passengerId': passengerId,
      'driverId': driverId,
      'requestTime': requestTime,
      'startTime': startTime,
      'endTime': endTime,
      'fare': fare,
      'status': status,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
    };
  }

  // Method to create a RideModel from a Map
  factory Ride.fromMap(Map<String, dynamic> map) {
    return Ride(
      rideId: map['rideId'],
      passengerId: map['passengerId'],
      driverId: map['driverId'],
      requestTime: (map['requestTime'] as Timestamp).toDate(),
      startTime: map['startTime'] != null ? (map['startTime'] as Timestamp).toDate() : null,
      endTime: map['endTime'] != null ? (map['endTime'] as Timestamp).toDate() : null,
      fare: map['fare'],
      status: map['status'],
      pickupLocation: map['pickupLocation'],
      dropoffLocation: map['dropoffLocation'],
    );
  }
}
