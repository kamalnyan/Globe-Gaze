import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/components/chatComponents/Chatusermodel.dart';
import 'package:globegaze/components/chatComponents/messege_card.dart';
import 'package:globegaze/themes/dark_light_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../apis/PushNotifaction.dart';
import '../../apis/chatdata.dart';
import '../../components/LoadingAnimation.dart';
import '../../components/chatComponents/messegemodel.dart';
import '../../components/mydate.dart';
import '../../main.dart';
import '../../themes/colors.dart';

class Messegescreen extends StatefulWidget {
  final ChatUser user;
  const Messegescreen({super.key, required this.user});
  @override
  State<Messegescreen> createState() => _MessegescreenState();
}

class _MessegescreenState extends State<Messegescreen> {
  List<Message> _list = [];
  final _msgcontroller = TextEditingController();
  bool _showemoji = false, _isUploading = false;
  @override
  void initState() {
    requestPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          if (_showemoji) {
            setState(() {
              _showemoji = false;
            });
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          backgroundColor:
              isDarkMode(context) ? DChatBack : ChatBack, // Dark background.
          appBar: AppBar(
            backgroundColor:
                isDarkMode(context) ? Color(0xFF1E1E2A) : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(CupertinoIcons.back,
                  color:
                      isDarkMode(context) ? Colors.white : Color(0xFF1E1E2A)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: StreamBuilder(
                stream: Apis.getUserInfo(widget.user),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;
                  final list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                  return Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage(
                            'assets/png_jpeg_images/user.png'), // User profile image
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            list.isNotEmpty ? list[0].name : widget.user.name,
                            style: TextStyle(
                              color: isDarkMode(context)
                                  ? Colors.white
                                  : Color(0xFF1E1E2A),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            list.isNotEmpty
                                ? list[0].isOnline
                                    ? 'Online'
                                    : MyDateUtil.getLastActiveTime( context: context, lastActive :widget
                                .user.lastActive.millisecondsSinceEpoch.toString())
                                : MyDateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: widget
                                        .user.lastActive.millisecondsSinceEpoch
                                        .toString()),
                            // Convert Timestamp to DateTime
                            style: TextStyle(
                              color: isDarkMode(context)
                                  ? Colors.white
                                  : Color(0xFF1E1E2A),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
            actions: [
              IconButton(
                icon: Icon(CupertinoIcons.phone,
                    color:
                        isDarkMode(context) ? Colors.white : Color(0xFF1E1E2A)),
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
                          child: Text(
                            'No Connection Found!🥺',
                            style: TextStyle(color: PrimaryColor, fontSize: 21),
                          ),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data!.docs;
                        _list = data
                                .map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: _list.length,
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
              if (_isUploading)
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: loadinganimation2())),
              _chatInput(),
              if (_showemoji)
                SizedBox(
                  height: mq.height * .35,
                  child: EmojiPicker(
                    textEditingController: _msgcontroller,
                    config: Config(
                      height: 256,
                      emojiViewConfig: EmojiViewConfig(
                        columns: 7,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.20 : 1.0),
                      ),
                      viewOrderConfig: const ViewOrderConfig(
                        top: EmojiPickerItem.searchBar,
                        middle: EmojiPickerItem.categoryBar,
                        bottom: EmojiPickerItem.emojiView,
                      ),
                      searchViewConfig: SearchViewConfig(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> requestPermissions() async {
    await Permission.camera.request();
    await Permission.storage.request();
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
            border: Border.all(
                color: Colors.white.withOpacity(0.2)), // Optional border
          ),
          padding: EdgeInsets.only(bottom: 20.0, top: 4, left: 3),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            setState(() => _showemoji = true);
                          },
                          icon: Icon(CupertinoIcons.smiley_fill),
                          color: PrimaryColor),
                      Expanded(
                        child: TextField(
                          controller: _msgcontroller,
                          decoration: const InputDecoration(
                            hintText: 'Send message...',
                            border: InputBorder.none,
                          ),
                          onTap: () {
                            setState(() {
                              _showemoji = false;
                            });
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            // Pick an image
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.camera, imageQuality: 70);
                            if (image != null) {
                              log('Image Path: ${image.path}');
                              setState(() => _isUploading = true);
                              await Apis.sendChatImage(
                                  widget.user, File(image.path));
                              setState(() => _isUploading = false);
                            }
                          },
                          icon: Icon(CupertinoIcons.photo_camera_solid),
                          color: PrimaryColor),
                      IconButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            // Picking multiple images
                            final List<XFile> images =
                                await picker.pickMultiImage(imageQuality: 70);
                            // uploading & sending image one by one
                            for (var i in images) {
                              log('Image Path: ${i.path}');
                              setState(() => _isUploading = true);
                              await Apis.sendChatImage(
                                  widget.user, File(i.path));
                              setState(() => _isUploading = false);
                            }
                          },
                          icon: Icon(CupertinoIcons.photo_fill),
                          color: PrimaryColor),
                    ],
                  ),
                ),
              ),
              CupertinoButton(
                child: const Icon(CupertinoIcons.paperplane_fill,
                    color: PrimaryColor, size: 27),
                onPressed: () {
                  if (_msgcontroller.text.isNotEmpty) {
                    Apis.sendMessage(
                        widget.user, _msgcontroller.text.trim(), Type.text);
                    _msgcontroller.text = "";
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
