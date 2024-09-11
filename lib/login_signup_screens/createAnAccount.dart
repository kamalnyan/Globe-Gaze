import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../components/login_signup_components.dart';
class Create_an_account extends StatefulWidget {
  @override
  State<Create_an_account> createState() => LoginState();
}
class LoginState extends State<Create_an_account> {
  TextEditingController _fullname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController  _phone= TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();
  late SharedPreferences shareP;
  @override
  void initState() {
    super.initState();
    sharePreferences();
  }
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: isDarkMode ? Color(0xFF121212) : Colors.white, // Professional dark and light background
        child: Stack(
          children: [
            // Background image section at the top
            TopSection(isDarkMode: isDarkMode, screenHeight: screenHeight),
            // Login form section at the bottom
            CbottomSection(isDarkMode: isDarkMode, screenHeight: screenHeight,
                fullname: _fullname,
                email: _email,
                phone: _phone,
                password: _password,
                confirmpassword: _confirmpassword,
                context: context
            ),
          ],
        ),
      ),
    );
  }
  // Shared Preference for welcome_Screen
  Future<void> sharePreferences() async {
    shareP = await SharedPreferences.getInstance();
    shareP.setBool('welcomedata', false);
  }
}