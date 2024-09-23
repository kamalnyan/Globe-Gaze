import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderName;
  final String content;
  final String timestamp;
  final String imageUrl;

  Message({required this.senderName, required this.content, required this.timestamp, required this.imageUrl});
  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Message(
      senderName: data['senderName'] ?? '',
      content: data['content'] ?? '',
      timestamp: data['timestamp'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
