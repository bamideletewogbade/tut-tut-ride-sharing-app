import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuk_tuk/models/ride_requests.dart';
import 'package:tuk_tuk/services/ride_service.dart';
import 'ride_request_dialog.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? mapController;
  LatLng _currentPosition = const LatLng(45.521563, -122.677433);
  int _selectedIndex = 0;
  final RideService _rideService = RideService();
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _createDummyRides();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 15.0),
        ),
      );
      _loadNearbyRides();
    });
  }

  void _loadNearbyRides() {
    _rideService.getNearbyRides(_currentPosition.latitude, _currentPosition.longitude, 5.0).listen((rides) {
      setState(() {
        _markers.clear();
        for (var ride in rides) {
          _markers.add(
            Marker(
              markerId: MarkerId(ride.rideId),
              position: LatLng(ride.pickupLocation.latitude, ride.pickupLocation.longitude),
              infoWindow: InfoWindow(
                title: 'Ride Available',
                snippet: 'From: ${ride.pickupLocation} To: ${ride.dropoffLocation}',
              ),
            ),
          );
        }
      });
    });
  }

  void _createDummyRides() async {
    // Create some dummy rides
    List<Ride> dummyRides = [
      Ride(
        rideId: '', // Firestore will auto-generate this ID
        userId: 'dummyUser1',
        driverId: 'dummyDriver1',
        pickupLocation: GeoPoint(45.521563, -122.677433),
        dropoffLocation: GeoPoint(45.531563, -122.677433),
        requestTime: DateTime.now(),
        fare: 10.0,
        status: 'available',
      ),
      Ride(
        rideId: '',
        userId: 'dummyUser2',
        driverId: 'dummyDriver2',
        pickupLocation: GeoPoint(45.531563, -122.677433),
        dropoffLocation: GeoPoint(45.541563, -122.677433),
        requestTime: DateTime.now(),
        fare: 15.0,
        status: 'available',
      ),
    ];

    for (var ride in dummyRides) {
      await _rideService.setRide(ride);
    }

    _loadNearbyRides();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle navigation to different screens based on the selected index
      // This is where you would use Navigator to push new routes
    });
  }

  void _showRideRequestDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return RideRequestDialog(
          onSubmit: (pickup, dropoff) {
            _createRideRequest(pickup, dropoff);
          },
        );
      },
    );
  }

  Future<void> _createRideRequest(String pickup, String dropoff) async {
    Ride ride = Ride(
      rideId: '', // Firestore will auto-generate this ID
      userId: 'testUser',
      driverId: 'testDriver',
      pickupLocation: GeoPoint(_currentPosition.latitude, _currentPosition.longitude),
      dropoffLocation: GeoPoint(0, 0), // Assume dropoff is not defined
      requestTime: DateTime.now(),
      fare: 10.0,
      status: 'pending',
    );
    await _rideService.setRide(ride);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Transport App'),
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 15.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: Set<Marker>.of(_markers),
          ),
          Positioned(
            bottom: 60,
            left: 10,
            right: 10,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _showRideRequestDialog,
                  child: Text('Request a Ride'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orangeAccent,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // ElevatedButton(
                //   onPressed: () {
                //     // TODO: Navigate to ride history screen
                //   },
                //   child: Text('Ride History'),
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.black,
                //     onPrimary: Colors.white,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(30.0),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Rides',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
