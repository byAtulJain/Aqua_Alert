import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:water_supply_management/booking.dart';
import 'package:water_supply_management/map_screen.dart';
import 'package:water_supply_management/reporting.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Aqua Alert',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Quick Access',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      gradient: _getGradientForIndex(index),
                    ),
                    child: Center(
                      child: Text(
                        [
                          'Tanker Booking',
                          'Highlighted Area',
                          'Reporting',
                          'Analysis'
                        ][index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 30.0),
              Text(
                'Water Consumption',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('zones').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No data available'));
                  }

                  final List<QueryDocumentSnapshot> documents =
                      snapshot.data!.docs;

                  // Sort documents by amount in descending order
                  documents.sort((a, b) {
                    final int amountA =
                        (a.data() as Map<String, dynamic>)['amount'] ?? 0;
                    final int amountB =
                        (b.data() as Map<String, dynamic>)['amount'] ?? 0;
                    return amountB.compareTo(amountA);
                  });

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final data =
                          documents[index].data() as Map<String, dynamic>;
                      final String zone = data['zone'] ?? 'Unknown Zone';
                      final int amount = data['amount'] ?? 0;

                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              gradient: _getGradientForIndex(index % 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(3.0, 3.0),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    zone,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '$amount L',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                            ),
                          ),
                          SizedBox(height: 10.0), // Space between items
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _getGradientForIndex(int index) {
    List<List<Color>> gradients = [
      [Colors.blue, Colors.purple],
      [Colors.red, Colors.orange],
      [Colors.green, Colors.teal],
      [Colors.deepPurple, Colors.indigo],
    ];

    return LinearGradient(
      colors: gradients[index % gradients.length],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
