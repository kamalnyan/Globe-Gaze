import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

import 'package:permission_handler/permission_handler.dart';

class addPost{
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static String uid = auth.currentUser!.uid;
  static User? user = auth.currentUser;
  static String? userId = uid;
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  // Upload to Firebase Storage
  static Future<String> _uploadToStorage(Uint8List fileData, String folder) async {
    final ref = FirebaseStorage.instance.ref().child('PostMedia').child(uid).child('$folder/${DateTime.now().toIso8601String()}');
    UploadTask uploadTask = ref.putData(fileData);
    final snapshot = await uploadTask.whenComplete(() => {});
    return await snapshot.ref.getDownloadURL();
  }
  static Future<void> uploadPostToFirebase(String postText, List<Map<String, dynamic>> mediaFiles, String? location) async {
    List<String> mediaUrls = [];
    // Upload media files to Firebase Storage
    for (var media in mediaFiles) {
      if (media['type'] == 'image') {
        String imageUrl = await _uploadToStorage(Uint8List.fromList(media['data']), 'PostsImg');
        mediaUrls.add(imageUrl);
      } else if (media['type'] == 'video') {
        File videoFile = media['file'];
        String videoUrl = await _uploadToStorage(videoFile.readAsBytesSync(), 'PostsVid');
        mediaUrls.add(videoUrl);
      }
    }

    // Save post to Firestore
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('Posts').add({
      'text': postText,
      'mediaUrls': mediaUrls,
      'location': location,
      'createdAt': Timestamp.now(),
    });
  }
  static Future<void> _fetchMedia() async {}
  static Future<void> requestPermissions() async {
    final PermissionStatus status = await Permission.photos.request();
    if (status.isGranted) {
      _fetchMedia();
    } else {
      print('Permission Denied');
    }
  }
}