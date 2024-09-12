import 'package:flutter/material.dart';
import 'package:globegaze/components/Elevated_button.dart';
import 'package:globegaze/themes/colors.dart';
import 'package:pinput/pinput.dart';

import '../themes/dark_light_switch.dart';
class otp_screen extends StatefulWidget {
  const otp_screen({super.key});
  @override
  State<otp_screen> createState() => _otp_screenState();
}

class _otp_screenState extends State<otp_screen> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black
      ),
      decoration: BoxDecoration(
        color: Colors.greenAccent.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent)
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: const Text('OTP',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          width: double.infinity,
          child: Column(
            children: [
              //  Text('Verification', style: TextStyle(
              //   color: LightDark(isDarkMode),
              //   fontSize: 28,
              //   fontWeight: FontWeight.bold,
              //    ),
              // ),
              Image(image: const AssetImage('assets/png_jpeg_images/otp.png'),height: 180,width: 180,),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child:  Text('Enter otp sent to your phone',
                  style: TextStyle(
                    color:LightDark(isDarkMode),
                    fontSize: 18
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child:  Text("+91 747 951 9946",
                  style: TextStyle(
                    color:LightDark(isDarkMode),
                    fontSize: 18,
                  ),
                ),
              ),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.green)
                  )
                ),
                onCompleted: (pin) => debugPrint(pin),
              ),
              SizedBox(height: 40,),
              SizedBox(
                width: 240,
                  height: 50,
                  child: Button(onPress:(){},text:"Verify",fontSize: 17.0,bgColor: PrimaryColor,fgColor: Colors.white, ))
            ],
          ),
        ),
      ),
    );
  }
}
