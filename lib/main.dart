import 'package:flutter/material.dart';
import 'Splash_Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Globe Gaze',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // Automatically switch based on system theme
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
      ),
      home:  MyHomePage(),
    );
  }
}



