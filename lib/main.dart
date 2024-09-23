import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/Screens/home_screens/main_home.dart';
import 'Splash_Screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EmailOTP.config(
    appName: 'Globe Gaze',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v1,
    otpLength: 6,
  );
  // EmailOTP.setSMTP(
  //   host: '<www.globegaze.com>',
  //   emailPort: EmailPort.port25,
  //   secureType: SecureType.tls,
  //   username: '<trythis7320@gmail.com>',
  //   password: '<Kamal@7320>',
  // );
  EmailOTP.setTemplate(
    template: '''
  <div style="background-color: #f7f7f7; padding: 40px; font-family: Arial, sans-serif;">
    <div style="background-color: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); max-width: 600px; margin: 0 auto;">
      <h2 style="color: #2c3e50; font-size: 24px; text-align: center;">{{appName}} Password Reset</h2>
      <hr style="border: none; border-bottom: 1px solid #e1e1e1; margin: 20px 0;">
      <p style="color: #2c3e50; font-size: 16px;">Dear User,</p>
      <p style="color: #2c3e50; font-size: 16px;">We received a request to reset your password for your {{appName}} account. Please use the following One-Time Password (OTP) to proceed:</p>
      <div style="background-color: #f0f4f8; padding: 15px; border-radius: 8px; text-align: center; font-size: 22px; font-weight: bold; color: #43dd8c; letter-spacing: 2px; margin: 20px 0;">
        {{otp}}
      </div>
      <p style="color: #2c3e50; font-size: 16px;">This OTP is valid for 5 minutes. If you did not request a password reset, please ignore this email.</p>
      <p style="color: #2c3e50; font-size: 16px;">If you have any questions or concerns, feel free to contact our support team.</p>
      <p style="color: #7f8c8d; font-size: 14px; text-align: center; margin-top: 40px;">Thank you for choosing {{appName}}.</p>
    </div>
  </div>
  ''',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Globe Gaze',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // Automatically switch based on system theme
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
      ),
      home:  MyHomePage(),
    );
  }
}



