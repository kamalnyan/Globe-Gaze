import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class addPost{
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static String uid = auth.currentUser!.uid;
  static User? user = auth.currentUser;
  static String? userId = uid;
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  static Future<void> uploadPostToFirebase(
      String postText,
      List<Map<String, dynamic>> mediaFiles,
      String? location,
      {required void Function(double) onProgress}
      ) async {
    List<String> mediaUrls = [];
    double totalFiles = mediaFiles.length.toDouble();
    double uploadedFiles = 0.0;

    // Upload media files to Firebase Storage
    for (var media in mediaFiles) {
      String mediaUrl;
      if (media['type'] == 'image') {
        mediaUrl = await _uploadToStorage(Uint8List.fromList(media['data']), 'PostsImg', (fileProgress) {
          onProgress((uploadedFiles + fileProgress) / totalFiles);
        });
      } else {
        continue;
      }
      mediaUrls.add(mediaUrl);
      uploadedFiles += 1.0;
      onProgress(uploadedFiles / totalFiles);
    }
    // Save post to Firestore
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('Posts').add({
      'text': postText,
      'mediaUrls': mediaUrls,
      'location': location,
      'createdAt': Timestamp.now(),
    });
  }

  static Future<String> _uploadToStorage(
      Uint8List fileData,
      String folderName,
      void Function(double) progressCallback,
      ) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('PostMedia')
        .child(uid)
        .child('$folderName/${DateTime.now().toIso8601String()}');
    UploadTask uploadTask = ref.putData(fileData);
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = snapshot.bytesTransferred / snapshot.totalBytes;
      progressCallback(progress); // Callback with upload progress
    });
    await uploadTask.whenComplete(() => null);
    return await ref.getDownloadURL();
  }
}