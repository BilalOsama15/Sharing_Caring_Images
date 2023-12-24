import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharing_image/AddGroup.dart';
import 'package:sharing_image/Authentication/PhoneAuthentication.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1), () {
      checkUserStatus();
    });  }
   void checkUserStatus() async {
    // Firebase Auth instance
    FirebaseAuth auth = FirebaseAuth.instance;

    // Check if the user is signed in
    User? user = auth.currentUser;
    if (user != null) {
      // User is signed in, navigate to home page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else {
      // User is not signed in, navigate to phone authentication screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const phoneAuthentication()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png',height: 50,),
            Text('WellCome to Sharing Caring Image', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}