import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/chatComponents/Chatusermodel.dart';
import '../components/chatComponents/messegemodel.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static String uid =auth.currentUser!.uid;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return firestore.collection('Users').where('Id',isNotEqualTo: uid).snapshots();
  }
  static String getConversationID(String id) => uid.hashCode <= id.hashCode
      ? '${uid}_$id'
      : '${id}_${uid}';
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    //message to send
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: uid,
        sent: time);
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }
}
