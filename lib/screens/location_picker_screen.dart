import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerScreen extends StatefulWidget {
  final Function(LatLng) onLocationPicked;

  const LocationPickerScreen({Key? key, required this.onLocationPicked}) : super(key: key);

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng _center = LatLng(37.7749, -122.4194); 
  LatLng? _pickedLocation;

  void _onTap(LatLng latlng) {
    setState(() {
      _pickedLocation = latlng;
    });
  }

  void _onConfirm() {
    if (_pickedLocation != null) {
      widget.onLocationPicked(_pickedLocation!);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a location!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pick a Location")),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: _center,
                zoom: 13.0,
                onTap: (_, latlng) => _onTap(latlng),
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.grocery_app',
                ),
                if (_pickedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40.0,
                        height: 40.0,
                        point: _pickedLocation!,
                        child: Icon(Icons.location_on, color: Colors.red, size: 40),
                      )
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _onConfirm,
              child: Text("Confirm Location"),
            ),
          ),
        ],
      ),
    );
  }
}
