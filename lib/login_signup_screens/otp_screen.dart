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
    double screenWidth = MediaQuery.of(context).size.width;
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
        title: const Text('OTP'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/png_jpeg_images/otp1.png',
                ),
              ),
              const SizedBox(
                height: 18,
              ),
               Text('Verification', style: TextStyle(
                color: LightDark(isDarkMode),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: const Text('Enter the code sent to your phone',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18
                  ),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(bottom: 20),
              //   child: const Text("+91 747 951 9946",
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 18,
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(left: screenWidth/16, right: screenWidth/16),
                child: Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(color: Colors.green)
                      )
                  ),
                  onCompleted: (pin) => debugPrint(pin),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 180,
                height: 50,
                child: Button(bgColor: PrimaryColor,fgColor: Colors.white,text: 'Verify',fontSize: 20.0,onPress: (){}),
              ),
              const SizedBox(height: 20),
               Text(
                "Didn't you receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: LightDark(isDarkMode),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                "Resend code",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: PrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

  }
}
