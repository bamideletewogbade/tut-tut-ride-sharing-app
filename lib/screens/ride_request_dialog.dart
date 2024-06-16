import 'package:flutter/material.dart';

class RideRequestDialog extends StatefulWidget {
  final Function(String, String) onSubmit;

  RideRequestDialog({required this.onSubmit});

  @override
  _RideRequestDialogState createState() => _RideRequestDialogState();
}

class _RideRequestDialogState extends State<RideRequestDialog> {
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Request a Ride'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _pickupController,
            decoration: InputDecoration(labelText: 'From'),
          ),
          TextField(
            controller: _dropoffController,
            decoration: InputDecoration(labelText: 'To'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final pickup = _pickupController.text.trim();
            final dropoff = _dropoffController.text.trim();
            if (pickup.isNotEmpty && dropoff.isNotEmpty) {
              widget.onSubmit(pickup, dropoff);
              Navigator.of(context).pop();
            }
          },
          child: Text('Search'),
        ),
      ],
    );
  }
}
