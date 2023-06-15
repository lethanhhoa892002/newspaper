import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/home.dart';
import 'package:food/main.dart';
import 'package:food/upnew.dart';

class viewNewpaper extends StatefulWidget {
  const viewNewpaper({required this.newID});
  final String newID;

  @override
  State<viewNewpaper> createState() => _viewNewpaperState();
}

class _viewNewpaperState extends State<viewNewpaper> {
  late final Stream<DocumentSnapshot> _newsStream;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _newsStream = FirebaseFirestore.instance
        .collection('newspaper')
        .doc(widget.newID)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _newsStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      data['title'],
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
                    ),
                    _buildContent(data),
                    SizedBox(
                      height: 10,
                    ),
                    Text(data['content']),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              showUnselectedLabels: true,
              selectedFontSize: 15,
              unselectedItemColor: Colors.grey,
              selectedItemColor: Colors.blue,
              iconSize: 30,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.upload_file), label: 'Up new'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.logout_outlined), label: 'Logout'),
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                switch (index) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                    break;
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const upNewpage()),
                    );
                    break;
                  case 2:
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()),
                    );
                    break;
                }
              },
            ),
          ),
        );
      },
    );
  }
}

Widget _buildContent(Map<String, dynamic> data) {
  if (data.containsKey('image') && data['image'] != null) {
    return Image.network(
      data['image'],
      height: 300,
      width: 300,
    );
  } else {
    return SizedBox(
      height: 20,
    );
  }
}
