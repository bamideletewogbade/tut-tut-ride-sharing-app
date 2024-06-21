import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuk_tuk/models/ride.dart'; // Import Ride model
import 'package:tuk_tuk/services/ride_service.dart';

import '../models/ride_requests.dart'; // Import RideService

class RidesScreen extends StatefulWidget {
  final LatLng userLocation;

  RidesScreen({required this.userLocation});

  @override
  _RidesScreenState createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  final RideService _rideService = RideService();
  late Stream<List<Ride>> _ridesStream;

  @override
void initState() {
  super.initState();
  _ridesStream = _rideService.getNearbyRides(
    widget.userLocation.latitude,
    widget.userLocation.longitude,
    5000, // 5000 meters (5 km) radius
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Rides'),
      ),
      body: StreamBuilder<List<Ride>>(
        stream: _ridesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No available rides.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Ride ride = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text('Ride ID: ${ride.rideId}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('From: ${ride.pickupLocation.latitude}, ${ride.pickupLocation.longitude}'),
                          Text('To: ${ride.dropoffLocation.latitude}, ${ride.dropoffLocation.longitude}'),
                          Text('Fare: \$${ride.fare.toStringAsFixed(2)}'),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Implement action when tapping on a ride
                        },
                        child: Text('Request Ride'),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
