import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globegaze/themes/colors.dart'; // If using SVGs for icons.

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2A), // Dark background.
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E2A),
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.white),
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(
                  'https://example.com/avatar_image.png'), // User profile image (replace this URL)
            ),
            SizedBox(width: 10),
            Text(
              'Jacob Jones',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: Colors.white),
            onPressed: () {
              // Call button action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Voice message bubble
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF32344A),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.graphic_eq, color: Colors.blueAccent), // Waveform icon
                          SizedBox(width: 10),
                          Text(
                            '02:43',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.play_circle_filled,
                            color: Colors.blueAccent,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Outgoing text message bubble
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color:PrimaryColor, // Blue message bubble
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'No, meet @ my house at 5:45. Then we can take the bus 2 the cinema.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Incoming text message bubble
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF32344A), // Dark message bubble
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'ok! c u later. =D',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Thumbs up emoji with a smartwatch
                Align(
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Text(
                        '👍',
                        style: TextStyle(fontSize: 50),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          child: Icon(Icons.watch), // This is the watch icon
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Typing indication and input field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Jacob is typing...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFF32344A),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Message...',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          // Send message action
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
