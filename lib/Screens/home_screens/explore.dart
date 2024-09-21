import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../themes/dark_light_switch.dart';

class explore extends StatefulWidget {
  const explore({super.key});

  @override
  State<explore> createState() => _exploreState();
}

class _exploreState extends State<explore> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Globe Gaze',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: LightDark(isDarkMode),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(CupertinoIcons.bell),
            tooltip: 'Search',
            onPressed: () {
              // Add your search action here
              print('Search button pressed');
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.bolt_horizontal_circle_fill),
            tooltip: 'Settings',
            onPressed: () {
              // Add your settings action here
              print('Settings button pressed');
            },
          ),
        ],
      ),
    );
  }
}
