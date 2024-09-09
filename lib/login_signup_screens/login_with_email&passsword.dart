import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: isDarkMode ? Color(0xFF121212) : Colors.white, // Professional dark and light background
        child: Stack(
          children: [
            // Background image section at the top
            TopSection(isDarkMode: isDarkMode),
            // Login form section at the bottom
            BottomSection(isDarkMode: isDarkMode),
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
// preload image
class TopSection extends StatelessWidget {
  final bool isDarkMode;
  const TopSection({
    required this.isDarkMode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 130.0, bottom: 130.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/png_jpeg_images/login_light.jpg'),
            fit: BoxFit.cover,
            colorFilter: isDarkMode
                ? ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken)
                : null, // Darken the image in dark mode
          ),
        ),
        child: Column(
          children: [
            Text(
              'Welcome to',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: const [
                  TextSpan(
                    text: 'G',
                    style: TextStyle(color: Color(0xff43dd8c)), // Accent color for 'G'
                  ),
                  TextSpan(text: 'LOBE'),
                  TextSpan(text: ' '),
                  TextSpan(
                    text: 'G',
                    style: TextStyle(color: Color(0xff43dd8c)), // Accent color for 'G'
                  ),
                  TextSpan(text: 'AZE'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class BottomSection extends StatelessWidget {
  final bool isDarkMode;

  const BottomSection({
    required this.isDarkMode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      top: 220,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white, // Professional background colors
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Color(0xff43dd8c) : Color(0xff43dd8c),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                autocorrect: true,
                autofocus: true,
                cursorColor: Color(0xff43dd8c),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.mail, color: isDarkMode ? Color(0xff43dd8c) : Color(0xff43dd8c)),
                  label: Text('Email or Phone', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: Color(0xff43dd8c)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                autocorrect: true,
                autofocus: true,
                cursorColor: Color(0xff43dd8c),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.lock, color: isDarkMode ? Color(0xff43dd8c) : Color(0xff43dd8c)),
                  label: Text('Password', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: Color(0xff43dd8c)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Forget and Create account
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('Forgot Password ?', style: TextStyle(color: isDarkMode ?Colors.white:Colors.black, fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Create an account', style: TextStyle(color: isDarkMode ?Colors.white:Colors.black, fontSize: 16)),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // login Button
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff43dd8c),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: Text('Login'),
                ),
              ),
              SizedBox(height: 16),
              Text('OR', style: TextStyle(fontSize: 18, color: isDarkMode ? Color(0xff43dd8c) : Colors.black)),
              SizedBox(height: 16),
              // Other login options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset('assets/svg_images/google-color-icon.svg', height: 40, width: 40),
                      ),
                      Text('Google', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 16)),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.apple), iconSize: 50),
                      Text('Apple', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 16)),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset('assets/svg_images/facebook-round-color-icon.svg', height: 40, width: 40),
                      ),
                      Text('Facebook', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}