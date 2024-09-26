import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/components/chatComponents/Chatusermodel.dart';

import '../../Screens/chat/messegescreen.dart';
import '../../main.dart';
import '../../themes/dark_light_switch.dart';

class Chatusercard extends StatefulWidget {
  final ChatUser user;
  const Chatusercard({super.key, required this.user});
  @override
  State<Chatusercard> createState() => _ChatusercardState();
}

class _ChatusercardState extends State<Chatusercard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .02, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17.0)),
      elevation: 0,
      color: isDarkMode(context) ? Color(0xFF4A4A4A) : Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Messegescreen(user:widget.user,)));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),  // Adds some vertical padding for better spacing
          child: ListTile(
            leading: const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/png_jpeg_images/user.png') as ImageProvider,
              backgroundColor: Colors.transparent,
            ),
            title: Text(widget.user.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode(context) ? Colors.white : Colors.black,  // Adapt title color to dark/light mode
              ),
            ),
            subtitle: Text(widget.user.about,maxLines: 1,
              style: TextStyle(
                color: isDarkMode(context) ? Colors.grey.shade400 : Colors.grey.shade600,  // Lighter text for subtitle in dark mode
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,  // Center the timestamp vertically
              children: [
                Text("12:32",
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.grey.shade500 : Colors.grey.shade600,  // Timestamp color according to mode
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
