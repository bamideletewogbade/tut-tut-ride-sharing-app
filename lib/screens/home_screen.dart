import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tuk_tuk/models/ride_requests.dart';
import 'package:tuk_tuk/services/ride_service.dart';
import 'ride_request_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? mapController;
  LatLng _currentPosition = const LatLng(45.521563, -122.677433);
  int _selectedIndex = 0;
  final RideService _rideService = RideService();

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
    });
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
      pickupLocation: pickup,
      dropoffLocation: dropoff,
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
        title: Text('Campus Transport'),
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
                    primary: Colors.orange,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to ride history screen
                  },
                  child: Text('Ride History'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
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
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
