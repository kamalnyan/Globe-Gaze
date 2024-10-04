import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globegaze/apis/chatdata.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../components/chatComponents/Chatusermodel.dart';
import '../../components/chatComponents/chatusercard.dart';
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
          body: StreamBuilder(
            stream: Apis.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Stack(
                    children: [
                      const Opacity(
                        opacity: 0.7,
                        child: ModalBarrier(dismissible: false, color: Colors.black),
                      ),
                      Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          size: 67,
                          color: PrimaryColor,
                        ),
                      ),
                    ],
                  );
                case ConnectionState.none:
                  return const Center(
                    child: Text('No connection'),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data!.docs;
                  _list = data.map((e) => ChatUser.fromJson(e.data())).toList();
                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      itemCount: _isSearching ? _searchList.length : _list.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Chatusercard(user: _isSearching ? _searchList[index] : _list[index]);
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "No Connection Found!🥺",
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
      ),
    );
  }
}
