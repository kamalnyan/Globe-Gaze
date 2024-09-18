import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/components/textfield.dart';
import 'package:globegaze/themes/colors.dart';
import 'package:globegaze/themes/dark_light_switch.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../components/Elevated_button.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Password'),
        backgroundColor: PrimaryColor,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            // margin: EdgeInsets.only(top: screenHieght*0.17),
            width: double.infinity,
            child: Column(
              children: [
                Text('Enter New Password', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,

                  color: LightDark(isDarkMode),
                ),
                ),
                 SizedBox(height: screenHieght/21),
                Padding(
                  padding:  EdgeInsets.only(left:context.screenWidth /17,right:context.screenWidth /17),
                  child: customTextField(isDarkMode: isDarkMode, name: 'New Password', obs: false, keyboradType: TextInputType.name, icon: CupertinoIcons.lock),
                ),
                SizedBox(height: screenHieght/25),
                Padding(
                  padding:  EdgeInsets.only(left:context.screenWidth /17,right:context.screenWidth /17),
                  child: customTextField(isDarkMode: isDarkMode, name: 'Confirm New Password', obs: false, keyboradType: TextInputType.name, icon: CupertinoIcons.lock),
                ),
                SizedBox(height: screenHieght/25),
                SizedBox(
                  width: 220,
                  height: 50,
                  child: Button(
                    onPress: () {},
                    text: 'Done',
                    bgColor: PrimaryColor,
                    fontSize: 17.0,
                    fgColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

