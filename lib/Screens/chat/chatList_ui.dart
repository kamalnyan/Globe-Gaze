import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globegaze/apis/APIs.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../components/chatComponents/Chatusermodel.dart';
import '../../components/chatComponents/GeminiAi.dart';
import '../../components/chatComponents/chatusercard.dart';
import '../../main.dart';
import '../../themes/colors.dart';
import '../../themes/dark_light_switch.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    super.initState();
    Apis.fetchUserInfo().then((value) {
      SystemChannels.lifecycle.setMessageHandler((message) async {
        log("Lifecycle message: $message");
        if (message.toString().contains("paused")) {
          Apis.updateActiveStatus(false);
        } else if (message.toString().contains("resumed")) {
          Apis.updateActiveStatus(true);
        }
        return message;
      });
    },);
  }
  List<ChatUser> _list = [];
  List<ChatUser> _searchList = [];
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (_isSearching) {
            setState(() {
              _isSearching = false;
              _searchController.clear();
              _searchList.clear();
            });
            return false; // Prevent default back navigation
          } else {
            return true; // Allow back navigation
          }
        },
        child: Scaffold(
          backgroundColor: isDarkMode(context) ? const Color(0xFF1E1E2A) : Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: isDarkMode(context) ? const Color(0xFF1E1E2A) : Colors.white,
            title: _isSearching
                ? CupertinoSearchTextField(
              autofocus: true,
              controller: _searchController,
              style: TextStyle(
                color: isDarkMode(context) ? Colors.white : Colors.black,
              ),
              onChanged: (value) {
                _searchList.clear();
                for (var i in _list) {
                  if (i.name.toLowerCase().contains(value.toLowerCase()) ||
                      i.email.toLowerCase().contains(value.toLowerCase()) ||
                      i.username.toLowerCase().contains(value.toLowerCase())) {
                    _searchList.add(i);
                  }
                }
                setState(() {});
              },
            )
                : const Text(
              'Messages',
              style: TextStyle(
                fontSize: 29,
                fontFamily: 'MonaSans',
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_isSearching ? CupertinoIcons.clear_thick : CupertinoIcons.search),
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _searchController.clear();
                      _searchList.clear();
                    }
                    _isSearching = !_isSearching;
                  });
                },
              ),
              const SizedBox(width: 10.0),
            ],
          ),
          body:  Column(
            children: [
              const SizedBox(
                height: 100,
                child: GeminiChatCard(),
              ),
              StreamBuilder(
                stream: Apis.getMyUsersId(),
                //get id of only known users
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                  //if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return CupertinoActivityIndicator();

                    case ConnectionState.active:
                    case ConnectionState.done:
                      return StreamBuilder(
                        stream: Apis.getAllUsers(snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                        //get only those user, who's ids are provided
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                          //if data is loading
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                            // return const Center(
                            //     child: CircularProgressIndicator());
                            //if some or all data is loaded then show it
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              _list = data
                                  ?.map((e) => ChatUser.fromJson(e.data()))
                                  .toList() ?? [];
                              if (_list.isNotEmpty) {
                                return Expanded(
                                  child: ListView.builder(
                                      itemCount: _isSearching
                                          ? _searchList.length
                                          : _list.length,
                                      padding: EdgeInsets.only(top: mq.height * .01),
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Chatusercard(
                                            user: _isSearching
                                                ? _searchList[index]
                                                : _list[index]);
                                      }),
                                );
                              } else {
                                return const Center(
                                  child: Text('No Connections Found!',
                                      style: TextStyle(fontSize: 20)),
                                );
                              }
                          }
                        },
                      );
                  }
                },
              ),
            ],
          )
        ),
      ),
    );
  }
}
