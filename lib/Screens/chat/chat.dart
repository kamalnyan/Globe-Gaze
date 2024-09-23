import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:globegaze/themes/colors.dart';
import 'package:globegaze/themes/dark_light_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'messege.dart';
class ChatList extends StatelessWidget {
  final List<Message> messages = [
    Message("Jenny Wilson", "Hi Peter! Do u want 2 come 2 the cinema tonight? 😏", "1 hour", "assets/avatar1.png"),
    Message("Theresa Webb", "That's great! I’m doing well, too. I am just messaging to ask if we ...", "1 hour", "assets/avatar2.png"),
    Message("Wade Warren", "Hi man! What film?", "1 hour", "assets/avatar3.png"),
    Message("Ronald Richards", "Is this your first time in Berlin? 😅", "1 hour", "assets/avatar4.png"),
    Message("Courtney Henry", "Do you have any holidays coming up?", "1 hour", "assets/avatar5.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages', style:TextStyle(fontSize: 26,fontWeight: FontWeight.w600,fontFamily:'MonaSans')),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return MessageTile(
            name: messages[index].name,
            message: messages[index].message,
            time: messages[index].time,
            avatarUrl: messages[index].avatarUrl,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(CupertinoIcons.chat_bubble_fill),
        backgroundColor: PrimaryColor,
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;

  MessageTile({required this.name, required this.message, required this.time, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(avatarUrl), // Replace with NetworkImage if using online avatars
        radius: 25,
      ),
      title: Text(name, style: TextStyle(color: LightDark(isDarkMode), fontWeight: FontWeight.bold)),
      subtitle: Text(message, style: TextStyle(color: LightDark(isDarkMode))),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: TextStyle(color: LightDark(isDarkMode))),
          SizedBox(height: 5),
          Icon(Icons.circle, size: 10, color: PrimaryColor),
        ],
      ),
      onTap: () {
        // Handle message tap
      },
    );
  }
}

class Message {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;

  Message(this.name, this.message, this.time, this.avatarUrl);
}