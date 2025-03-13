import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng _indoreLatLng = LatLng(22.7196, 75.8577);
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: _indoreLatLng,
    zoom: 12.0,
  );

  final Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    _fetchCircleLocations();
  }

  Future<void> _fetchCircleLocations() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('circle_location').get();
      final Set<Circle> circles = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final LatLng position = LatLng(data['latitude'], data['longitude']);
        return Circle(
          circleId: CircleId(doc.id),
          center: position,
          radius: 1000,
          strokeWidth: 2,
          strokeColor: Colors.red,
          fillColor: Colors.red.withOpacity(0.1),
        );
      }).toSet();

      setState(() {
        _circles.addAll(circles);
      });
    } catch (e) {
      print('Error fetching circle locations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Highlighted Area',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        circles: _circles,
      ),
    );
  }
}
