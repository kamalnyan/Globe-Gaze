import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/components/Elevated_button.dart';
import 'package:globegaze/themes/colors.dart';

import '../../apis/chatdata.dart';
import '../login_signup_screens/login_with_email_and_passsword.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage>  {
 final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Button(
          onPress:() {
            _auth.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
          },
          fontSize: 21.0,
          text: 'Signout',
          fgColor: Colors.white,
          bgColor: PrimaryColor
        ),
      ),
    );
  }
}
