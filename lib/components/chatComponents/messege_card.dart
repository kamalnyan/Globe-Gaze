import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/components/chatComponents/messegemodel.dart';

import '../../apis/chatdata.dart';
import '../../main.dart';

class MessegeCard extends StatefulWidget {
  final Message message;
  const MessegeCard({super.key, required this.message});
  @override
  State<MessegeCard> createState() => _MessegeCardState();
}

class _MessegeCardState extends State<MessegeCard> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Apis.uid == widget.message.fromId
          ? Alignment.centerRight // Align to right if it's the user's message
          : Alignment.centerLeft, // Align to left if it's from the other user
      child: Apis.uid == widget.message.fromId
          ? _greenMessage() // User's messages will be in green
          : _blueMessage(), // Other user's messages will be in blue
    );
  }
  // sender or another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    // if (widget.message.read.isEmpty) {
    //   Apis.updateMessageReadStatus(widget.message);
    // }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: widget.message.type == Type.text
                ?
            //show text
            Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            )
                :
            //show image
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: CachedNetworkImage(
                imageUrl: widget.message.msg,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.image, size: 70),
              ),
            ),
          ),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text("12:32",
            // MyDateUtil.getFormattedTime(
            //     context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  // our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message time
        Row(
          children: [
            //for adding some space
            SizedBox(width: mq.width * .04),

            //double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            //for adding some space
            const SizedBox(width: 2),

            //sent time
            Text("12:36",
              // MyDateUtil.getFormattedTime(
              //     context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),

        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: widget.message.type == Type.text
                ?
            //show text
            Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            )
                :
            //show image
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: CachedNetworkImage(
                imageUrl: widget.message.msg,
                placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.image, size: 70),
              ),
            ),
          ),
        ),
      ],
    );
  }
  // Widget _greenMessege() {
  //   return Container(
  //     padding: EdgeInsets.all(12),
  //     margin: EdgeInsets.only(left: 50, right: 10, bottom: 10),
  //     decoration: BoxDecoration(
  //       color: Colors.blueAccent,
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Text(
  //       widget.message.msg,
  //       style: TextStyle(color: Colors.white, fontSize: 16),
  //     ),
  //   );
  // }
  // Widget _blueMessege() {
  //   return Container(
  //     padding: EdgeInsets.all(12),
  //     margin: EdgeInsets.only(right: 50, left: 10, bottom: 10),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[300],
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Text(
  //       widget.message.msg,
  //       style: TextStyle(color: Colors.black, fontSize: 16),
  //     ),
  //   );
  // }
}

