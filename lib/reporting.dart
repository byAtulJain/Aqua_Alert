import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportScreen extends StatefulWidget {
  final User user;

  ReportScreen({required this.user});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController _messageController = TextEditingController();

  Future<Map<String, dynamic>?> _getUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  void _submitReport(
      String name, String mobile, String address, String pincode) async {
    String message = _messageController.text.trim();

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a message')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('reports').add({
      'name': name,
      'mobile': mobile,
      'address': address,
      'pincode': pincode,
      'message': message,
      'user_id': widget.user.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Report submitted successfully')),
    );

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Submit a Report',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data available'));
          } else {
            final userData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildListTile(
                      title: 'Name',
                      subtitle: userData['name'] ?? 'Not provided',
                    ),
                    SizedBox(height: 16.0),
                    _buildListTile(
                      title: 'Mobile Number',
                      subtitle: userData['phone'] ?? 'Not provided',
                    ),
                    SizedBox(height: 16.0),
                    _buildListTile(
                      title: 'Address',
                      subtitle: userData['address'] ?? 'Not provided',
                    ),
                    SizedBox(height: 16.0),
                    _buildListTile(
                      title: 'Pincode',
                      subtitle: userData['pincode'] ?? 'Not provided',
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
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: 'Message',
                          labelStyle: TextStyle(fontSize: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 12.0),
                        ),
                        maxLines: 4,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _submitReport(
                            userData['name'] ?? 'Not provided',
                            userData['phone'] ?? 'Not provided',
                            userData['address'] ?? 'Not provided',
                            userData['pincode'] ?? 'Not provided',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text('Submit Report',
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

  Widget _buildListTile({required String title, required String subtitle}) {
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
