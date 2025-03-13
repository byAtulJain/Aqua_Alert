import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TankBookingScreen extends StatefulWidget {
  final User user;

  TankBookingScreen({required this.user});

  @override
  _TankBookingScreenState createState() => _TankBookingScreenState();
}

class _TankBookingScreenState extends State<TankBookingScreen> {
  final List<String> _capacityOptions = [
    '6000 liters (Full Tank)',
    '3000 liters (Half Tank)'
  ];
  String? _selectedCapacity;
  String? _price;
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();
    if (!userDoc.exists) {
      throw Exception('User data not found');
    }
    return userDoc.data() as Map<String, dynamic>;
  }

  void _updatePrice() {
    if (_selectedCapacity == '6000 liters (Full Tank)') {
      setState(() {
        _price = '600 Rs';
      });
    } else if (_selectedCapacity == '3000 liters (Half Tank)') {
      setState(() {
        _price = '300 Rs';
      });
    } else {
      setState(() {
        _price = null;
      });
    }
  }

  void _submitBooking() async {
    if (_selectedCapacity == null || _price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please select a tank capacity and check the price')),
      );
      return;
    }

    try {
      final userData = await _userDataFuture;

      await FirebaseFirestore.instance.collection('tank_bookings').add({
        'name': userData['name'],
        'address': userData['address'],
        'phone': userData['phone'],
        'pincode': userData['pincode'],
        'capacity': _selectedCapacity,
        'price': _price,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking submitted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Tank Booking',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data available'));
          } else {
            final userData = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfoTile(
                        title: 'Name',
                        subtitle: userData['name'] ?? 'Not available'),
                    SizedBox(height: 16.0),
                    _buildUserInfoTile(
                        title: 'Address',
                        subtitle: userData['address'] ?? 'Not available'),
                    SizedBox(height: 16.0),
                    _buildUserInfoTile(
                        title: 'Phone No',
                        subtitle: userData['phone'] ?? 'Not available'),
                    SizedBox(height: 16.0),
                    _buildUserInfoTile(
                        title: 'Pincode',
                        subtitle: userData['pincode'] ?? 'Not available'),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedCapacity,
                        decoration: InputDecoration(
                          labelText: 'Tank Capacity',
                          labelStyle: TextStyle(fontSize: 16.0),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        items: _capacityOptions.map((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child:
                                Text(option, style: TextStyle(fontSize: 16.0)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCapacity = value;
                            _updatePrice();
                          });
                        },
                        hint: Text('Select Capacity',
                            style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: TextEditingController(text: _price),
                        decoration: InputDecoration(
                          labelText: 'Price',
                          labelStyle: TextStyle(fontSize: 16.0),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        readOnly: true,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text('Submit Booking',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildUserInfoTile({required String title, required String subtitle}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 16.0)),
      ),
    );
  }
}
