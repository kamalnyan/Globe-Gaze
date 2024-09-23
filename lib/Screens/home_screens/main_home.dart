import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/themes/colors.dart';
import '../../themes/customappbar.dart';
import '../../themes/dark_light_switch.dart';
import 'explore.dart';
import 'search.dart';
import 'add.dart';
import 'trips.dart';
import 'profile.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _page = 0;
  bool isDarkMode = false; // Toggle between dark/light mode
  final PageController _pageController = PageController(initialPage: 0);

  // List of pages for bottom navigation
  final List<Widget> _pages = [
    Explore(), // Page 0
    SearchPage(),  // Page 1
    AddPage(),     // Page 2
    Trips(),   // Page 3
    ProfilePage(), // Page 4
  ];

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: buildAppBar(_page, isDarkMode,context), // Apply the dynamic AppBar
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
        children: _pages,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe gesture
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        height: 70,
        backgroundColor: isDarkMode ? Colors.black38 : Colors.white,
        activeColor: PrimaryColor,
        color: isDarkMode ? Colors.white : Colors.black38,
        items: [
          TabItem(icon: Icons.explore, title: 'Explore'),
          TabItem(icon: Icons.search, title: 'Search'),
          TabItem(icon: Icons.add, title: 'Add'),
          TabItem(icon: Icons.train, title: 'Trips'),
          TabItem(icon: Icons.account_circle, title: 'Profile'),
        ],
        initialActiveIndex: _page, // Sync with current page
        onTap: (int index) {
          setState(() {
            _page = index;
          });
          _pageController.jumpToPage(index); // Navigate to the selected page
        },
      ),
    );
  }
}
