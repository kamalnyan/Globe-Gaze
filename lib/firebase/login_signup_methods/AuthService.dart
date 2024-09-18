import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/firebase/login_signup_methods/sendverifaction.dart';
import '../../Screens/login_signup_screens/login_with_email_and_passsword.dart';
import '../../components/AlertDilogbox.dart';
import '../../themes/colors.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> signUpWithEmailPassword({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required BuildContext context
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password,);
      final user = userCredential.user;
      if (user != null) {
        final uid = user.uid;
        await _firestore.collection('Users').doc(uid).set({
          'FullName': fullName,
          'Email': email,
          'Phone': phone,
          'CreatedAt': Timestamp.now(),
        });
        await sendVerificationEmail(user,context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created Scuessfully'),
            backgroundColor: PrimaryColor,),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Login()));
      }
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AlertDialogBox(context: context,animationType: CoolAlertType.error,message: "The password provided is too weak.",title: "Error");
      } else if (e.code == 'email-already-in-use') {
        AlertDialogBox(context: context,animationType: CoolAlertType.error,message: "The account already exists for that email.",title: "Error");
      } else if (e.code == 'invalid-email') {
        AlertDialogBox(context: context,animationType: CoolAlertType.error,message: "The email address is badly formatted.",title: "Error");
      } else if (e.code == 'operation-not-allowed') {
        AlertDialogBox(context: context,animationType: CoolAlertType.error,message: "Signing in with Email and Password is not enabled.",title: "Error");
      } else {
        AlertDialogBox(context: context,animationType: CoolAlertType.error,message: "An unexpected error occurred: ${e.message}",title: "Error");
      }
    } catch (e) {
      AlertDialogBox(context: context,animationType: CoolAlertType.error,message: "An unexpected error occurred: ${e.toString()}",title: "Error");
    }
  }
}
