import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../apis/APIs.dart';
import '../../themes/colors.dart';
import '../login_signup_screens/login_with_email_and_passsword.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker picker = ImagePicker();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(  // Drawer implementation
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Profile Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),

            // Profile Menu Items in Drawer
            ProfileMenuWidget(
                title: "Settings",
                icon: CupertinoIcons.settings,
                onPress: () {
                  Navigator.pop(context); // Close drawer before navigating
                  // Handle settings navigation here
                }),
            ProfileMenuWidget(
              title: "Logout",
              icon: CupertinoIcons.square_arrow_left,  // Logout icon
              textColor: Colors.red,
              endIcon: false,
              onPress: () {
                Navigator.pop(context); // Close drawer before showing dialog
                _showLogoutDialog(context); // Call the logout confirmation dialog
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
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
                      child:
                      CachedNetworkImage(
                        imageUrl: Apis.me.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, // You can also use ImageSource.camera if needed
                          imageQuality: 70,
                        );

                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() => _isUploading = true);
                          try {
                              Apis.uploadProfilePicture(File(image.path));
                            setState(() => _isUploading = false);
                          } catch (e) {
                            print('Error sending image: $e');
                            setState(() => _isUploading = false);
                          }
                        } else {
                          print('No image selected');
                        }
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: PrimaryColor),
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

              // Replace undefined constants with actual text or ensure they are defined in your app
              Text(Apis.me.name,),
              Text(Apis.me.about,),
              const SizedBox(height: 20),

              /// -- EDIT PROFILE BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle navigation to update profile
                    // Replace with your navigation method or screen
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => UpdateProfileScreen()),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PrimaryColor,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("LOGOUT"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                      (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {

    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor = isDark ? PrimaryColor : Colors.white;

    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconColor.withOpacity(0.1),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)),
      trailing: endIcon? Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(CupertinoIcons.right_chevron, size: 18.0, color: Colors.grey)) : null,
    );
  }
}
