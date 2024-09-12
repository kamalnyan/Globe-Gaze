import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/login_signup_components.dart';
class CreateAnAccount extends StatefulWidget {
  const CreateAnAccount({super.key});

  @override
  State<CreateAnAccount> createState() => CreateAccountState();
}
class CreateAccountState extends State<CreateAnAccount> {
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController  _phone= TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
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
        color: isDarkMode ? const Color(0xFF121212) : Colors.white,
        child: Stack(
          children: [
            // Background image section at the top
            topSection(isDarkMode: isDarkMode, screenHeight: screenHeight),
            // Login form section at the bottom
            cbottomSection(isDarkMode: isDarkMode, screenHeight: screenHeight,
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