import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  final String phoneNumber;

  AdminPage({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: Center(
        child: Text(
          'Welcome, Admin! Phone number: $phoneNumber',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
