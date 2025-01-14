import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seat_allocation/view/Adminhome.dart';

class ViewExamhalls extends StatefulWidget {
  ViewExamhalls({Key? key}) : super(key: key);

  @override
  State<ViewExamhalls> createState() => _ViewExamhallsState();
}

class _ViewExamhallsState extends State<ViewExamhalls> {
  late Future<QuerySnapshot> examhallFuture;

  // Create a GlobalKey for the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    examhallFuture = fetchExamhall();
  }

  Future<QuerySnapshot> fetchExamhall() async {
    return FirebaseFirestore.instance.collection('examhall').get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey to the Scaffold
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 19, 57, 85),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminHome(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Add your notification icon onPressed logic here
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              // Add user details here, e.g., user profile image
              backgroundImage:
                  NetworkImage('https://example.com/user_profile_image.jpg'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Container(
            width: 380,
            height: 36,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 19, 57, 85),
            ),
            child: Center(
              child: Text(
                'Examhalls List',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          FutureBuilder<QuerySnapshot>(
            future: examhallFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                return Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Hall ID')),
                        DataColumn(label: Text('Capacity')),
                        // Add more columns if needed
                      ],
                      rows: documents.map((document) {
                        final data = document.data() as Map<String, dynamic>;
                        return DataRow(cells: [
                          DataCell(Text(document
                              .id)), // Assuming 'hall_id' is stored as the document ID
                          DataCell(Text(data['capacity'].toString())),
                          // Add more cells if needed
                        ]);
                      }).toList(),
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
