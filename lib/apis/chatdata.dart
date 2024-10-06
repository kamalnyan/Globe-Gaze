import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../components/chatComponents/Chatusermodel.dart';
import '../components/chatComponents/messegemodel.dart';
import 'PushNotifaction.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static String uid = auth.currentUser!.uid;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static User? user = auth.currentUser;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('Users')
        .where('Id', isNotEqualTo: uid)
        .snapshots();
  }

  static String getConversationID(String id) =>
      uid.hashCode <= id.hashCode ? '${uid}_$id' : '${id}_${uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: uid,
        sent: time);
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        FCMService.sendPushNotification(chatUser.pushToken,me.name,msg),
      );
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  static ChatUser me = ChatUser(
      id: '',
      name: '',
      email: '',
      about: '',
      image: '',
      createdAt: Timestamp.now(),
      isOnline: false,
      lastActive: Timestamp.now(),
      pushToken: '',
      username: '');
  // Storing Self user inform
  static Future<void> fetchUserInfo() async {
    try {
      if (user == null) throw Exception("No user is currently logged in.");
      final DocumentSnapshot userDoc =
          await firestore.collection('Users').doc(user!.uid).get();
      if (userDoc.exists) {
        me = ChatUser.fromJson(userDoc.data() as Map<String, dynamic>);
        log("User info fetched successfully: ${me?.name}");
        await getFirebaseMessagingToken();
        await updateActiveStatus(true);
      } else {
        log("No user document found for UID: ${user!.uid}");
      }
    } catch (e) {
      log("Error fetching user info: $e");
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('Users')
        .where('Id', isEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('Users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
      'lastActive': Timestamp.now(),
      'pushToken':me.pushToken
    });
  }

  // PushNotifaction
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
      }
    });
  }
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
}
