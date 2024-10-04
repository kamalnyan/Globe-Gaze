import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/components/chatComponents/Chatusermodel.dart';
import 'package:globegaze/components/chatComponents/messege_card.dart';
import 'package:globegaze/themes/dark_light_switch.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../apis/chatdata.dart';
import '../../components/chatComponents/messegemodel.dart';
import '../../themes/colors.dart';

class Messegescreen extends StatefulWidget {
  final ChatUser user;
  const Messegescreen({super.key, required this.user});
  @override
  State<Messegescreen> createState() => _MessegescreenState();
}

class _MessegescreenState extends State<Messegescreen> {
  List<Message> _list =[];
  final  _msgcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context)?DChatBack:ChatBack, // Dark background.
      appBar: AppBar(
        backgroundColor: isDarkMode(context)?Color(0xFF1E1E2A):Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: isDarkMode(context)?Colors.white:Color(0xFF1E1E2A)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage('assets/png_jpeg_images/user.png'), // User profile image
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.name,
                  style: TextStyle(
                    color: isDarkMode(context)?Colors.white:Color(0xFF1E1E2A),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text("12:32", // Display last active time
                  style: TextStyle(
                    color: isDarkMode(context)?Colors.white:Color(0xFF1E1E2A),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.phone, color: isDarkMode(context)?Colors.white:Color(0xFF1E1E2A)),
            onPressed: () {
              // Call button action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: Apis.getAllMessages(widget.user),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    // return
                    return SizedBox();
                  case ConnectionState.none:
                    return const Center(
                      child: Text('No Connection Found!🥺',style: TextStyle(color: PrimaryColor,fontSize: 21),),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data!.docs;
                    _list = data.map((e) => Message.fromJson(e.data())).toList()??[];
                    if (_list.isNotEmpty) {
                      return ListView.builder(
                        reverse: true,
                        itemCount:_list.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return MessegeCard(message: _list[index]);
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "Say Hii👋",
                          style: TextStyle(fontSize: 25),
                        ),
                      );
                    }
                  default:
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                }
              },
            ),
          ),
          _chatInput(),
        ],
      ),
    );
  }
  Widget _chatInput() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2), // Transparent background
            borderRadius: BorderRadius.circular(20), // Same rounded corners
            border: Border.all(color: Colors.white.withOpacity(0.2)), // Optional border
          ),
          padding: EdgeInsets.only(bottom: 20.0, top: 4, left: 3),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  child: Row(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.smiley_fill), color: PrimaryColor),
                      Expanded(
                        child: TextField(
                          controller: _msgcontroller,
                          decoration: const InputDecoration(
                            hintText: 'Send message...',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                          },
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.photo_camera_solid), color: PrimaryColor),
                      IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.photo_fill), color: PrimaryColor),
                    ],
                  ),
                ),
              ),
              CupertinoButton(
                child: Icon(CupertinoIcons.paperplane_fill, color: PrimaryColor, size: 27),
                onPressed: (){
                  if(_msgcontroller.text.isNotEmpty){
                    Apis.sendMessage(widget.user, _msgcontroller.text.trim(), Type.text);
                    _msgcontroller.text="";
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
