import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:water_supply_management/reporting.dart';
import 'booking.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'user_profile.dart';

class BottomNavBar extends StatefulWidget {
  final User user;

  BottomNavBar({required this.user});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(),
      MapScreen(), // Replace with your Map Screen
      TankBookingScreen(
        user: widget.user,
      ), // Replace with your Tanker Booking Screen
      ReportScreen(
          user: widget.user), // Replace with your Tanker Booking Screen
      ProfileScreen(user: widget.user),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(
                fontFamily: 'Mulish',
              ),
            ),
            selectedColor: Colors.blueAccent,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.map),
            title: Text(
              'Map',
              style: TextStyle(
                fontFamily: 'Mulish',
              ),
            ),
            selectedColor: Colors.greenAccent,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.airport_shuttle),
            title: Text(
              'Booking',
              style: TextStyle(
                fontFamily: 'Mulish',
              ),
            ),
            selectedColor: Colors.pinkAccent,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.comment),
            title: Text(
              'Report',
              style: TextStyle(
                fontFamily: 'Mulish',
              ),
            ),
            selectedColor: Colors.redAccent,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'Mulish',
              ),
            ),
            selectedColor: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }
}
