import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/components/textfield.dart';
import 'package:globegaze/login_signup_screens/forget_password.dart';
import 'package:globegaze/themes/colors.dart';
import 'package:globegaze/themes/dark_light_switch.dart';
import 'package:velocity_x/velocity_x.dart';

import '../components/Elevated_button.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    // Get the screen width dynamically
    double screenHieght = MediaQuery.of(context).size.height;

    // Set a dynamic margin based on the screen width
    double dynamicMargin = screenHieght * 0.22;
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Password'),
        backgroundColor: PrimaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: dynamicMargin),
          width: double.infinity,
          child: Column(
            children: [
              Text('Enter New Password', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,

                color: LightDark(isDarkMode),
              ),
              ),
              const SizedBox(
                height: 18,
              ),
              Padding(
                padding:  EdgeInsets.all(context.screenWidth * 0.2),
                child: customTextField(isDarkMode: isDarkMode, name: 'New Password', obs: false, keyboradType: TextInputType.name, icon: CupertinoIcons.lock),
              ),
              const SizedBox(
                height: 18,
              ),
              Padding(
                padding:  EdgeInsets.all(context.screenWidth * 0.2),
                child: customTextField(isDarkMode: isDarkMode, name: 'Confirm New Password', obs: false, keyboradType: TextInputType.name, icon: CupertinoIcons.lock),
              ),
              const SizedBox(
                height: 18,
              ),
              SizedBox(
                width: 220,
                height: 50,
                child: Button(
                  onPress: () {},
                  text: 'Send',
                  bgColor: PrimaryColor,
                  fontSize: 17.0,
                  fgColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

