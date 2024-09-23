import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/chat/messegeui.dart';
import 'Screens/home_screens/main_home.dart';
import 'Screens/login_signup_screens/login_with_email_and_passsword.dart';
import 'welcomescreen/welcomemain.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences? shareP;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    sharePreferences();
  }

  Future<void> sharePreferences() async {
    shareP = await SharedPreferences.getInstance();
    bool showWelcomeScreen = shareP?.getBool('welcomedata') ?? true;
    User? currentUser = _auth.currentUser;
    Timer(Duration(seconds: 5), () {
      if (showWelcomeScreen) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
      } else if (currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainHome()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: isDarkMode ? Colors.black : Colors.white, // Background color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 25,
                  color: isDarkMode ? Colors.white : Color(0xff48566a), // Text color
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'G',
                    style: TextStyle(color: Color(0xff43dd8c)),
                  ),
                  TextSpan(text: 'LOBE'),
                  TextSpan(text: ' '),
                  TextSpan(
                    text: 'G',
                    style: TextStyle(color: Color(0xff43dd8c)),
                  ),
                  TextSpan(text: 'AZE'),
                ],
              ),
            ),
            SizedBox(height: 40),
            Lottie.asset(
              isDarkMode
                  ? 'assets/lottie_animation/darkanimationspalsh.json'
                  : 'assets/lottie_animation/lightanimationspalsh.json',
            ),
          ],
        ),
      ),
    );
  }
}
