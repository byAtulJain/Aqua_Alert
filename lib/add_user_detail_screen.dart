import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bottom_nav_bar.dart';

class AddUserDetailScreen extends StatefulWidget {
  final User user;
  final Map<String, dynamic>? initialData;

  AddUserDetailScreen({required this.user, this.initialData});

  @override
  _AddUserDetailScreenState createState() => _AddUserDetailScreenState();
}

class _AddUserDetailScreenState extends State<AddUserDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedFamilyMembers;
  String? _selectedAreaType;
  String? _selectedGender;

  final List<String> _familyMemberOptions = ['1-4', '4-8', '8-12'];
  final List<String> _areaTypeOptions = ['Residential', 'Non-Residential'];
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = data['name'] ?? '';
        _addressController.text = data['address'] ?? '';
        _pincodeController.text = data['pincode'] ?? '';
        _emailController.text = data['email'] ?? '';
        _selectedFamilyMembers = data['family_members'];
        _selectedAreaType = data['area_type'];
        _selectedGender = data['gender'];
      });
    }
  }

  void _saveDetails() async {
    String name = _nameController.text.trim();
    String address = _addressController.text.trim();
    String pincode = _pincodeController.text.trim();
    String email = _emailController.text.trim();

    if (name.isEmpty ||
        address.isEmpty ||
        pincode.isEmpty ||
        email.isEmpty ||
        _selectedFamilyMembers == null ||
        _selectedAreaType == null ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .set({
      'name': name,
      'address': address,
      'pincode': pincode,
      'email': email,
      'phone': widget.user.phoneNumber,
      'family_members': _selectedFamilyMembers,
      'area_type': _selectedAreaType,
      'gender': _selectedGender,
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavBar(user: widget.user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User Details',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                controller: _nameController,
                label: 'Name',
              ),
              SizedBox(height: 16.0),
              _buildInputField(
                controller: _addressController,
                label: 'Address',
              ),
              SizedBox(height: 16.0),
              _buildInputField(
                controller: _pincodeController,
                label: 'Pincode',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              _buildInputField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              _buildDropdownField(
                value: _selectedFamilyMembers,
                label: 'Family Members',
                items: _familyMemberOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedFamilyMembers = value;
                  });
                },
              ),
              SizedBox(height: 20),
              _buildDropdownField(
                value: _selectedAreaType,
                label: 'Area Type',
                items: _areaTypeOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedAreaType = value;
                  });
                },
              ),
              SizedBox(height: 20),
              _buildDropdownField(
                value: _selectedGender,
                label: 'Gender',
                items: _genderOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text('Save',
                      style: TextStyle(fontSize: 16.0, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
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
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
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
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        ),
        items: items.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
        hint: Text('Select $label'),
      ),
    );
  }
}
