import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globegaze/components/textfield.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../login_signup_screens/Create_An_Account.dart';
import '../login_signup_screens/otp_screen.dart';
import '../themes/colors.dart';
import '../themes/dark_light_switch.dart';
import 'Elevated_button.dart';
import 'EmailValidator.dart';
Widget topSection({required bool isDarkMode, required double screenHeight}) {
  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Container(
      padding: EdgeInsets.only(
        top: screenHeight * 0.2,
        bottom: screenHeight * 0.2,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/png_jpeg_images/login_light.jpg'),
          fit: BoxFit.cover,
          colorFilter: isDarkMode
              ? ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken)
              : null,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Welcome to',
            style: TextStyle(color: Colors.white, fontSize: 21),
          ),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: 'G', style: TextStyle(color: PrimaryColor)),
                TextSpan(text: 'LOBE'),
                TextSpan(text: ' '),
                TextSpan(text: 'G', style: TextStyle(color: PrimaryColor)),
                TextSpan(text: 'AZE'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
Widget bottomSection({required bool isDarkMode, required double screenHeight, required BuildContext context,
  required TextEditingController email,
  required TextEditingController password,
}) {
  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    top: screenHeight * 0.34,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkLight(isDarkMode),
        borderRadius: const BorderRadius.only(
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
            // Login Title
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: PrimaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Email or Phone TextField
            customTextField(isDarkMode: isDarkMode, name: 'Email Or Phone',icon: Icons.email,obs: false,keyboradType: TextInputType.text,controllerr: email),
            const SizedBox(height: 16),
            // Password TextField
            customTextField(isDarkMode: isDarkMode, name: 'Password',icon: CupertinoIcons.lock,obs:true,keyboradType: TextInputType.text,controllerr: password),
            const SizedBox(height: 16),
            // Forgot Password and Create Account links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: LightDark(isDarkMode),
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const CreateAnAccount()));
                  },
                  child: Text(
                    'Create an account',
                    style: TextStyle(
                      color:  LightDark(isDarkMode),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Get Started Button
            SizedBox(
              width: 350,
              height: 50,
              child: Button(
                onPress: () {},
                text: 'Login',
                bgColor: PrimaryColor,
                fontSize: 17.0,
                fgColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // OR divider
            Text(
              'OR',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? PrimaryColor : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            // Social login options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/svg_images/google-color-icon.svg',
                        height: 40,
                        width: 40,
                      ),
                    ),
                    Text(
                      'Google',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.apple),
                      iconSize: 50,
                    ),
                    Text(
                      'Apple',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/svg_images/facebook-round-color-icon.svg',
                        height: 40,
                        width: 40,
                      ),
                    ),
                    Text(
                      'Facebook',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
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
Widget cbottomSection({required bool isDarkMode, required double screenHeight,
  required TextEditingController fullname,
  required TextEditingController email,
  required TextEditingController phone,
  required TextEditingController password,
  required TextEditingController confirmpassword,
  required BuildContext context
}) {
  FocusNode focusNode = FocusNode();
  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    top: screenHeight * 0.30,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkLight(isDarkMode),
        borderRadius: const BorderRadius.only(
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
            // Login Title
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Create your account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: PrimaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Email or Phone TextField
            customTextField(isDarkMode: isDarkMode, name: 'Full Name',icon: Icons.account_circle,obs: false,keyboradType: TextInputType.name,controllerr: fullname),
            const SizedBox(height: 16),
            // Phone TextField
            IntlPhoneField(
              controller: phone,
              keyboardType: TextInputType.phone,
              cursorColor: PrimaryColor,
              style: TextStyle(color: LightDark(isDarkMode)),
              // focusNode: focusNode,
              decoration: InputDecoration(
                label: Text('Phone Number',style: TextStyle(color:LightDark(isDarkMode)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.0),
                  borderSide: const BorderSide(color: PrimaryColor),
                ),
              ),
              dropdownIcon: const Icon(Icons.arrow_drop_down_outlined,color: PrimaryColor,),
              languageCode: "en",
              initialCountryCode: 'IN',
              dropdownTextStyle: const TextStyle(color: PrimaryColor),
            ),
            const SizedBox(height: 16),
            // Email TextField
            customTextField(isDarkMode: isDarkMode, name: 'Email',icon: Icons.email,obs: false,keyboradType: TextInputType.emailAddress,controllerr: email),
            const SizedBox(height: 16),
            // Password TextField
            customTextField(isDarkMode: isDarkMode, name: 'Password',icon: CupertinoIcons.lock,obs: true,keyboradType: TextInputType.text,controllerr: password),
            const SizedBox(height: 16),
            // Password TextField
            customTextField(isDarkMode: isDarkMode, name: 'Confirm Password',icon: CupertinoIcons.lock,obs: true,keyboradType: TextInputType.text,controllerr: confirmpassword),
            const SizedBox(height: 32),
            // Forgot Password and Create Account links
            SizedBox(
              width: 300,
              height: 50,
              child: Button(
                  text: 'Signup',
                  bgColor: PrimaryColor,
                  fontSize: 17.0,
                  fgColor: Colors.white,
                  onPress: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>otp_screen()));
                    // Fetching Input
                    final fullName = fullname.text.toString();
                    final emaill = email.text.toString();
                    final phonee = phone.text.toString();
                    final passwordd = password.text.toString();
                    final confirmPassword = confirmpassword.text.toString();
                    // Validating Inputs
                    if (fullName.isEmpty || fullName.length < 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(
                            'Full Name must be at least 3 characters long'),backgroundColor: PrimaryColor,),
                      );
                    } else if (phonee.isEmpty || phonee.length != 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Phone number must be 10 digits'),backgroundColor: PrimaryColor,),
                      );
                    } else if (!isValidEmail(emaill)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid email'),backgroundColor: PrimaryColor,),
                      );
                    } else if (passwordd.isEmpty || passwordd.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(
                            'Password must be at least 6 characters long'),backgroundColor: PrimaryColor,),
                      );
                    } else if (passwordd != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match'),backgroundColor: PrimaryColor,),
                      );
                    }
                  }
              ),
            ),
            const SizedBox(height: 16),
            // OR divider
            // Text(
            //   'OR',
            //   style: TextStyle(
            //     fontSize: 18,
            //     color: isDarkMode ? PrimaryColor : Colors.black,
            //   ),
            // ),
            // SizedBox(height: 16),
            // // Social login options
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Column(
            //       children: [
            //         IconButton(
            //           onPressed: () {},
            //           icon: SvgPicture.asset(
            //             'assets/svg_images/google-color-icon.svg',
            //             height: 40,
            //             width: 40,
            //           ),
            //         ),
            //         Text(
            //           'Google',
            //           style: TextStyle(
            //             color: isDarkMode ? Colors.white : Colors.black,
            //             fontSize: 16,
            //           ),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         IconButton(
            //           onPressed: () {},
            //           icon: Icon(Icons.apple),
            //           iconSize: 50,
            //         ),
            //         Text(
            //           'Apple',
            //           style: TextStyle(
            //             color: isDarkMode ? Colors.white : Colors.black,
            //             fontSize: 16,
            //           ),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         IconButton(
            //           onPressed: () {},
            //           icon: SvgPicture.asset(
            //             'assets/svg_images/facebook-round-color-icon.svg',
            //             height: 40,
            //             width: 40,
            //           ),
            //         ),
            //         Text(
            //           'Facebook',
            //           style: TextStyle(
            //             color: isDarkMode ? Colors.white : Colors.black,
            //             fontSize: 16,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    ),
  );
}