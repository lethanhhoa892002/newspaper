import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:food/main.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SreenRegister extends StatefulWidget {
  const SreenRegister({super.key});

  @override
  State<SreenRegister> createState() => _SreenRegisterState();
}

class _SreenRegisterState extends State<SreenRegister> {
  final _formfield = GlobalKey<FormState>();

  TextEditingController? nameCtrl,
      gmailCtrl,
      passCtrl,
      confirmPassCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController();
    gmailCtrl = TextEditingController();
    passCtrl = TextEditingController();
    confirmPassCtrl = TextEditingController();
  }

  Future<void> registerEmail(String email, String pass) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      final uid = credential.user?.uid;
      final firestore = FirebaseFirestore.instance;
      firestore.collection('users').doc(uid).set({
        'gmail': email,
        'id': uid,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  // Future createUser(User user) async {
  //   final docUser = FirebaseFirestore.instance.collection('User').doc();
  //   user.id = docUser.id;
  //   final json = user.toJson();
  //   await docUser.set(json);
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formfield,
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                      child: Text(
                    'Register',
                    style: TextStyle(fontSize: 30),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('By signing in you are agreeing'),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('our '),
                      Text(
                        'terms and privacy policy',
                        style: TextStyle(color: Colors.blue),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.transparent,
                                shadows: [
                                  Shadow(
                                      offset: Offset(0, -10),
                                      color: Colors.grey)
                                ],
                                decorationColor: Colors.black),
                          )),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.transparent,
                                shadows: [
                                  Shadow(
                                      offset: Offset(0, -10),
                                      color: Colors.blue)
                                ],
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.black),
                          )),
                    ],
                  ),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                        hintText: 'Filed Name',
                        prefixIcon: Icon(Icons.perm_identity_outlined)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'nhap ten';
                      }
                      bool nameReg = RegExp(r'^[a-zA-Z]+$').hasMatch(value);
                      if (!nameReg) {
                        return "Nhap lai ten";
                      }
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: gmailCtrl,
                    decoration: InputDecoration(
                        hintText: 'Email Address',
                        prefixIcon: Icon(Icons.email)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'nhap email';
                      }
                      bool emailReg =
                          RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                              .hasMatch(value);
                      if (!emailReg) {
                        return 'email nhap khong dung';
                      }
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      TextFormField(
                        controller: passCtrl,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          bool passReg = RegExp(r'^.{6,18}$').hasMatch(value);
                          if (!passReg) {
                            return 'Password phai tu 6 den 18 ki tu';
                          }
                        },
                      ),
                      SvgPicture.asset('images/hide.svg')
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      TextFormField(
                        controller: confirmPassCtrl,
                        decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock_outline)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'nhap password';
                          }

                          if (value != passCtrl!.text) {
                            return 'Password khong giong ';
                          }
                        },
                      ),
                      SvgPicture.asset('images/hide.svg')
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final gmail = gmailCtrl!.text.trim();
                        final pass = passCtrl!.text.trim();
                        setState(() {
                          if (_formfield.currentState!.validate()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                          }
                        });
                        registerEmail(gmail, pass);
                      },
                      child: Text(
                        'Register',
                      ),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(7.0)))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('or connect with'),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('images/facebook1.svg'),
                      const SizedBox(
                        width: 20,
                      ),
                      SvgPicture.asset('images/instagram1.svg'),
                      const SizedBox(
                        width: 20,
                      ),
                      SvgPicture.asset('images/pinterest1.svg'),
                      const SizedBox(
                        width: 20,
                      ),
                      SvgPicture.asset('images/linkedin1.svg')
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
