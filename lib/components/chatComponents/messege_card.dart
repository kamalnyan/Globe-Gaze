import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/components/chatComponents/messegemodel.dart';
import 'package:globegaze/themes/dark_light_switch.dart';

import '../../apis/chatdata.dart';
import '../../main.dart';
import '../../themes/colors.dart';
import '../mydate.dart';

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
          ? _Sender() // User's messages will be in green
          : _Reciver(), // Other user's messages will be in blue
    );
  }
  // sender or another user message
  Widget _Reciver() {
    if (widget.message.read.isEmpty) {
      Apis.updateMessageReadStatus(widget.message);
    }
    return Container(
      padding: EdgeInsets.all(widget.message.type == Type.image
          ? mq.width * .03
          : mq.width * .04),
      margin: EdgeInsets.symmetric(
          horizontal: mq.width * .04, vertical: mq.height * .01),
      decoration: BoxDecoration(
          color: isDarkMode(context) ? DReciverBackg : ReciverBackg,
          //making borders curved
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: widget.message.type == Type.text
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.msg,
                  style: TextStyle(
                      fontSize: 15,
                      color: isDarkMode(context) ? DReciverTxt : ReciverTxt),
                ),
                Padding(
                  padding: EdgeInsets.only(right: mq.width * .04),
                  child: Text(MyDateUtil.getFormattedTime(
                      context: context, time: widget.message.sent),
                    style: TextStyle(fontSize: 13, color:isDarkMode(context) ? DTimetxt : Timetxt),
                  ),
                ),
              ],
            )
          :
          //show image
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: SizedBox(
          width: 150, // Set desired width
          height: 150, // Set desired height
          child: CachedNetworkImage(
            fit: BoxFit.cover,
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
    );

  }
  // our or user message
  Widget _Sender() {
    return Container(
      padding: EdgeInsets.all(widget.message.type == Type.image
          ? mq.width * .03
          : mq.width * .04),
      margin: EdgeInsets.symmetric(
          horizontal: mq.width * .04, vertical: mq.height * .01),
      decoration: BoxDecoration(
          color: isDarkMode(context) ? PrimaryColor: PrimaryColor,
          //making borders curved
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30))),
      child: widget.message.type == Type.text
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.message.msg,
                  style: TextStyle(
                      fontSize: 15,
                      color: isDarkMode(context) ? DSenderTxt : SenderTxt),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //sent time
                    Text(MyDateUtil.getFormattedTime(
                        context: context, time: widget.message.sent),
                      style:TextStyle(fontSize: 13, color: isDarkMode(context)?DTimetxt:Timetxt),
                    ),
                    SizedBox(width: 2),
                    if (widget.message.read.isNotEmpty)
                      const Icon(Icons.done_all_rounded,
                          color: Colors.blue, size: 20),
                  ],
                ),
              ],
            )
          :
          //show image
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: SizedBox(
              width: 150, // Set desired width
              height: 150, // Set desired height
              child: CachedNetworkImage(
                fit: BoxFit.cover,
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //sent time
              Text(MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
                style:TextStyle(fontSize: 13, color: isDarkMode(context)?DTimetxt:Timetxt),
              ),
              SizedBox(width: 2),
              if (widget.message.read.isNotEmpty)
                const Icon(Icons.done_all_rounded,
                    color: Colors.blue, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
