import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:globegaze/Screens/chat/chatList_ui.dart';
import 'package:globegaze/Screens/home_screens/profile.dart';
import 'package:globegaze/Screens/home_screens/search.dart';
import 'package:globegaze/Screens/home_screens/trips.dart';
import '../../firebase/login_signup_methods/username.dart';
import '../../themes/colors.dart';
import '../../themes/dark_light_switch.dart';
import 'add.dart';
import 'explore.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _page = 0;
  bool isDarkMode = false;
  final PageController _pageController = PageController(initialPage: 0);
  String? username;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }
  Future<void> fetchUsername() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        String? fetchedUsername = await getUsernameFromFirestore(uid);
        setState(() {
          username = fetchedUsername ?? 'Guest';
          isLoading = false;
        });
      } catch (e) {
        print('Error fetching username: $e');
        setState(() {
          username = 'Error';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        username = 'Guest';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: buildAppBar(_page, isDarkMode, context, isLoading ? 'Loading...' : username),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
        children: _pages,
        physics: const NeverScrollableScrollPhysics(),
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
        initialActiveIndex: _page,
        onTap: (int index) {
          setState(() {
            _page = index;
          });
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

  PreferredSizeWidget? buildAppBar(int pageIndex, bool isDarkMode, BuildContext context, String? username) {
    switch (pageIndex) {
      case 0:
        return AppBar(
          backgroundColor: darkLight(isDarkMode),
          title: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 25,
                color: LightDark(isDarkMode),
              ),
              children: [
                TextSpan(
                  text: 'E',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PrimaryColor,
                    fontSize: 26,
                  ),
                ),
                TextSpan(text: 'xplore'),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(CupertinoIcons.bell),
              onPressed: () {
                // Notification action
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.facebookMessenger),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatList()));
              },
            ),
            const SizedBox(width: 15),
          ],
        );
      case 1:
        return AppBar(
          backgroundColor: darkLight(isDarkMode),
          actions: [
            Container(
              width: 340,
              height: 44,
              child: SearchBar(
                hintText: 'Search',
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onTap: () {
                  // Open search suggestions or results
                },
                leading: const Icon(Icons.search),
              ),
            ),
          ],
        );
      case 2:
        return null; // No AppBar on this page
      case 3:
        return AppBar(
          backgroundColor: darkLight(isDarkMode),
          title: const Text("My Trips"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: () {
                // Action to add a new trip
              },
            ),
          ],
        );
      case 4:
        return AppBar(
          backgroundColor: darkLight(isDarkMode),
          title: Text(username ?? 'Profile'), // Use the fetched username
          actions: [
            GestureDetector(
              child: Icon(CupertinoIcons.line_horizontal_3),
              onTap: () {},
            ),
            SizedBox(width: 25),
          ],
        );
      default:
        return AppBar(
          title: const Text("Default"),
        );
    }
  }

  // List of pages for bottom navigation
  final List<Widget> _pages = [
    Explore(),
    SearchPage(),
    AddPage(),
    Trips(),
    ProfilePage(),
  ];
}
