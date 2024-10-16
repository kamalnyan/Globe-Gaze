import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../apis/APIs.dart';
import '../../components/LoadingAnimation.dart';
import '../../components/profile/editprofile.dart';
import '../../themes/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker picker = ImagePicker();
  bool _isUploading = false;

  // Profile data (mocked)
  String fullName = Apis.me.name;
  String email = Apis.me.email;
  String phone = Apis.me.Phone;
  String username = Apis.me.username;
  String about = Apis.me.about;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: Apis.me.image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator()),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/png_jpeg_images/user.png'),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 70,
                            );

                            if (image != null) {
                              setState(() => _isUploading = true);
                              try {
                                String imageUrl = await Apis.uploadProfilePicture(
                                    File(image.path));
                                setState(() {
                                  Apis.me.image = imageUrl; // Update the image URL
                                  _isUploading = false;
                                });
                              } catch (e) {
                                log('Error sending image: $e');
                                setState(() => _isUploading = false);
                              }
                            } else {
                              log('No image selected');
                            }
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: PrimaryColor,
                            ),
                            child: const Icon(
                              CupertinoIcons.pencil,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(fullName),
                  Text(about),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      showEditProfileBottomSheet(
                        context,
                        fullName: fullName,
                        email: email,
                        username: username,
                        about: about,
                        phone: phone,
                        onSaveChanges: (updatedData) {
                          setState(() {
                            if (updatedData.containsKey('FullName')) {
                              fullName = updatedData['FullName'];
                            }
                            if (updatedData.containsKey('Email')) {
                              email = updatedData['Email'];
                            }
                            if (updatedData.containsKey('Phone')) {
                              phone = updatedData['Phone'];
                            }
                            if (updatedData.containsKey('Username')) {
                              username = updatedData['Username'];
                            }
                            if (updatedData.containsKey('About')) {
                              about = updatedData['About'];
                            }
                          });
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PrimaryColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    icon: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.black),
                    ),
                    label: const Icon(
                      CupertinoIcons.right_chevron,
                      size: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          if (_isUploading)
            const Opacity(
              opacity: 0.7,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),

          if (_isUploading)
            Center(
              child: uploadingAnimation(),
            ),
        ],
      ),
    );
  }
}
