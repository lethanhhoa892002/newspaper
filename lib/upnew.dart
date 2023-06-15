import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/home.dart';
import 'package:food/main.dart';

class upNewpage extends StatefulWidget {
  const upNewpage({Key? key}) : super(key: key);

  @override
  State<upNewpage> createState() => _upNewpageState();
}

class _upNewpageState extends State<upNewpage> {
  TextEditingController contentCtrl = TextEditingController();
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController urlCtrl = TextEditingController();
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                hintText: 'Title',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: contentCtrl,
              decoration: InputDecoration(
                labelText: 'content',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
              ),
              minLines: 3,
              maxLines: 10,
            ),
            TextField(
              controller: urlCtrl,
              decoration: InputDecoration(
                hintText: 'Url anh',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newspaper = Newspaper(
                  title: titleCtrl.text,
                  content: contentCtrl.text,
                  // image: urlCtrl.text
                );
                createPaper(newspaper: newspaper);
              },
              child: Text('upbai'),
            ),
          ],
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
        onTap: (tim) {
          setState(() {
            _selectedIndex = tim;
          });
          switch (tim) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
              break;
            case 1:
              break;
            case 2:
              FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
              break;
          }
        },
      ),
    ));
  }

  Future createPaper({required Newspaper newspaper}) async {
    final taonewspaper =
        FirebaseFirestore.instance.collection('newspaper').doc();
    newspaper.id = taonewspaper.id;
    await taonewspaper.set(newspaper.toJson());
  }
}

class Newspaper {
  String id;
  final String title;
  final String content;
  // final String image;
  Newspaper({
    this.id = '',
    required this.title,
    required this.content,
    // required this.image
  });

  Map<String, dynamic> toJson() => {
        'id newspaper': id,
        'title': title,
        'content': content,
        // 'image': image,
      };
  static Newspaper fromJson(Map<String, dynamic> json) => Newspaper(
        id: json['id newspaper'],
        title: json['title'],
        content: json['content'],
        // image: json['image']
      );
}
