import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:globegaze/Screens/chat/chat.dart';
import '../locationservices/current location.dart';
import 'colors.dart';
import 'dark_light_switch.dart'; // Your theme handling file

PreferredSizeWidget? buildAppBar(int pageIndex, bool isDarkMode,BuildContext context) {
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatList()));
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
        title: const Text("Profile"),
      );
    default:
      return AppBar(
        title: const Text("Default"),
      );
  }
}
