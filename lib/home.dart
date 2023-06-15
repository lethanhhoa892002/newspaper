import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:food/main.dart';
import 'package:food/newspaper.dart';

import 'package:food/upnew.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'BáoNews',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 30,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: (Colors.grey),
                        ),
                      ),
                      child: Center(
                        child: Text('ALL'),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: (Colors.grey),
                        ),
                      ),
                      child: Center(
                        child: Text('KHOA HỌC'),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: (Colors.grey),
                        ),
                      ),
                      child: Center(
                        child: Text('ĐỜI SỐNG'),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: (Colors.grey),
                        ),
                      ),
                      child: Center(
                        child: Text('XÃ HỘI'),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: (Colors.grey),
                        ),
                      ),
                      child: Center(
                        child: Text('LỊCH SỮ'),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: (Colors.grey),
                        ),
                      ),
                      child: Center(
                        child: Text('PANDA'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<List<Newspaper>>(
                  stream: readNewspapers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final newspapers = snapshot.data!;
                      return ListView(
                        children: newspapers.map(buildNewspaper2).toList(),
                      );
                    } else {
                      return Text('lỗi vãi ');
                    }
                  },
                ),
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
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            switch (index) {
              case 0:
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const upNewpage()),
                );
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
      ),
    );
  }

  Widget buildNewspaper2(Newspaper newspaper) {
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => viewNewpaper(newID: newspaper.id)));
          },
          child: Stack(
            children: [
              Container(
                height: 100,
                width: 370,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
              Positioned(
                  top: 10,
                  left: 10,
                  child: Text(
                    newspaper.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  )),
              Positioned(
                  top: 40,
                  left: 10,
                  child: Container(
                    width: 200,
                    child: Text(
                      newspaper.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),

              Positioned(
                right: 10,
                child: newspaper.image != null
                    ? SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(newspaper.image.toString()),
                      )
                    : Container(
                        height: 100,
                        width: 100,
                      ),
              ),
              // if (newspaper.image.toString() == null)
              //   Positioned(
              //     right: 10,
              //     child: Container(
              //       height: 100,
              //       width: 100,
              //     ),
              //   ),
            ],
          ),
        )
      ],
    );
  }

  Stream<List<Newspaper>> readNewspapers() => FirebaseFirestore.instance
      .collection('newspaper')
      .snapshots()
      .map((snapshots) => snapshots.docs.map((doc) {
            final data = doc.data();
            return Newspaper(
              id: doc.id,
              title: data['title'] ?? '',
              content: data['content'] ?? '',
              image: data['image'] ?? null,
            );
          }).toList());
}
