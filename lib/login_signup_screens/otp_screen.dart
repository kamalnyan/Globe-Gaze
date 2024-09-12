import 'package:flutter/material.dart';
import 'package:globegaze/themes/colors.dart';
import 'package:pinput/pinput.dart';

class otp_screen extends StatefulWidget {
  const otp_screen({super.key});

  @override
  State<otp_screen> createState() => _otp_screenState();
}

class _otp_screenState extends State<otp_screen> {
  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(20),
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          width: double.infinity,
          child: Column(
            children: [
              const Text('Verification', style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                 ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: const Text('Enter the code sent to your email',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: const Text("+91 747 951 9946",
                  style: TextStyle(
                    color: Colors.black,
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
            ],
          ),
        ),
      ),
    );
  }
}
