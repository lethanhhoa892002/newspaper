import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:food/register.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController? gmailCtrl,
      passCtrl,
      confirmPassCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gmailCtrl = TextEditingController();
    passCtrl = TextEditingController();
    confirmPassCtrl = TextEditingController();
  }

  loginEmail(String email, String pass) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      if (credential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Center(
                    child: Text(
                  'Login',
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
                        onPressed: () {},
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.transparent,
                              shadows: [
                                Shadow(
                                    offset: Offset(0, -10), color: Colors.blue)
                              ],
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SreenRegister()));
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.transparent,
                              shadows: [
                                Shadow(
                                    offset: Offset(0, -10), color: Colors.grey)
                              ],
                              decorationColor: Colors.black),
                        )),
                  ],
                ),
                TextField(
                  controller: gmailCtrl,
                  decoration: InputDecoration(
                      hintText: 'Email Address', prefixIcon: Icon(Icons.email)),
                ),
                SizedBox(
                  height: 25,
                ),
                Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    TextField(
                      controller: passCtrl,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline)),
                    ),
                    SvgPicture.asset('images/hide.svg')
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    Text(
                      'Remember password',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Forget password',
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    )
                  ],
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
                      setState(() {});

                      loginEmail(gmail, pass);
                    },
                    child: Text(
                      'Login',
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0)))),
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
    );
  }
}
