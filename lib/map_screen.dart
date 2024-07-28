import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;

  final LatLng _indoreCenter =
      LatLng(22.7196, 75.8577); // Coordinates for Indore
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _setMarkers() {
    // Add markers for specific locations in Indore
    _markers.add(Marker(
      markerId: MarkerId('marker1'),
      position: LatLng(22.7196, 75.8577), // Example location
      infoWindow: InfoWindow(
        title: 'Indore Center',
        snippet: 'Main area of Indore',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ));

    // Add more markers as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Indore Map',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _indoreCenter,
          zoom: 12.0, // Adjust zoom level as needed
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
