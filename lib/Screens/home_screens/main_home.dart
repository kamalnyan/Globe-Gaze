import 'package:flutter/material.dart';
import 'package:globegaze/themes/colors.dart';
class MainHome extends StatelessWidget {
  const MainHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        backgroundColor: PrimaryColor,
      ),
      body: Text('Welcome to Homepage'),
    );
  }
}
