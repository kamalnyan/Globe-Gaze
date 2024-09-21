import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:globegaze/Screens/home_screens/explore.dart';
import 'package:globegaze/Screens/profile/profile.dart';
import 'package:globegaze/themes/colors.dart'; // Assuming this imports your custom colors

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _selectedIndex = 0; // Track the selected tab

  // Function to switch between different tabs
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Create a list of widgets corresponding to each tab's content
  final List<Widget> _pages = <Widget>[
    const explore(),
    const explore(),
    const explore(),
    const explore(),
    const profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the content based on the selected tab
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        height: 60,
        curveSize: 100,
        top: -25,
        color: Colors.white,
        backgroundColor: PrimaryColor, // Using the custom PrimaryColor
        items: const [
          TabItem(icon: Icons.explore, title: 'Explore'),
          TabItem(icon: Icons.search, title: 'Search'),
          TabItem(icon: Icons.add_circle, title: 'Create'),
          TabItem(icon: CupertinoIcons.car_detailed, title: 'Active Trip'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: _selectedIndex, // Set the initial tab
        onTap: _onItemTapped, // Handle tab selection
      ),
    );
  }
}
