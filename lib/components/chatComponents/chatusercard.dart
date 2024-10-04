import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/apis/chatdata.dart';
import 'package:globegaze/components/chatComponents/Chatusermodel.dart';
import 'package:globegaze/firebase/usermodel/messege_model.dart';

import '../../Screens/chat/messegescreen.dart';
import '../../main.dart';
import '../../themes/colors.dart';
import '../../themes/dark_light_switch.dart';
import '../mydate.dart';

class Chatusercard extends StatefulWidget {
  final ChatUser user;
  const Chatusercard({super.key, required this.user});

  @override
  State<Chatusercard> createState() => _ChatusercardState();
}

class _ChatusercardState extends State<Chatusercard> {
  Message? _messages;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .02, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17.0)),
      elevation: 0,
      color: isDarkMode(context) ? const Color(0xFF4A4A4A) : Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Messegescreen(user: widget.user)));
        },
        child: StreamBuilder(
          stream: Apis.getLastMessages(widget.user),
          builder: (context, snapshot) {
            // Check for data, error, and loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading data.'));
            }

            // Safely access data only if snapshot has data and it's not empty
            final data = snapshot.data?.docs;
            if (data != null && data.isNotEmpty && data.first.exists) {
              _messages = Message.fromJson(data.first.data());
            } else {
              _messages = null;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),  // Adds some vertical padding for better spacing
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/png_jpeg_images/user.png') as ImageProvider,
                  backgroundColor: Colors.transparent,
                ),
                title: Text(
                  widget.user.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode(context) ? Colors.white : Colors.black,  // Adapt title color to dark/light mode
                  ),
                ),
                subtitle: _messages != null
                    ? (_messages!.type == Type.image
                    ? const Row(
                  children: [
                    Icon(CupertinoIcons.photo_fill_on_rectangle_fill, size: 16), // Display the image icon
                    SizedBox(width: 5), // Add some space between the icon and the text
                    Text("Image"), // Display the text "Image"
                  ],
                ) : Text(_messages!.msg)) : Text(widget.user.about),
                trailing: _messages == null
                    ? null //show nothing when no message is sent
                    : _messages!.read.isEmpty &&
                    _messages!.fromId != Apis.uid
                    ?
                //show for unread message
                const SizedBox(
                  width: 15,
                  height: 15,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 230, 119),
                        borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                  ),
                )
                    :
                //message sent time
                Text(
                  MyDateUtil.getLastMessageTime(
                      context: context, time: _messages!.sent),
                  style:  TextStyle(color: isDarkMode(context)?Timetxt:DTimetxt,fontSize: 13.0),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
