import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/my_text_field.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/components/round_tile.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign user in method
  void signUserIn() {}

  void signUserUp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(AppLocalizations.of(context)!.helloWorld),
                // Logo
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 90.0),
                  child: Image.asset(
                    'lib/assets/images/appIcon.png',
                  ),
                ),

                const SizedBox(
                  height: 39.05,
                ),

                // App name
                const Text("InsectInsight", style: CustomTextStyles.appName),

                const SizedBox(
                  height: 56,
                ),

                // Username textfield
                MyTextField(
                  controller: usernameController,
                  obscureText: false,
                  prefixIcon: const Icon(Icons.email, color: Colors.black),
                  hintText: 'Email',
                  showRevealButton: false,
                ),

                const SizedBox(
                  height: 13,
                ),

                // Password textfield
                MyTextField(
                  controller: passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock, color: Colors.black),
                  hintText: 'Password',
                  showRevealButton: true,
                ),

                const SizedBox(
                  height: 10,
                ),

                // Forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: CustomTextStyles.forgotPass,
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                // Sign in button
                MySubmitButton(
                  onTap: signUserIn,
                  buttonText: 'Sign In',
                ),

                const SizedBox(
                  height: 10,
                ),

                // Sign up button
                MySubmitButton(
                  onTap: signUserUp,
                  buttonText: 'Sign Up',
                ),

                const SizedBox(
                  height: 50,
                ),

                // Viet+Eng icon button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Vietnam icon
                    GestureDetector(
                      onTap: () => const (Locale('vi'),),
                      child: const RoundTile(
                          imagePath: 'lib/assets/images/Flag_of_Vietnam.png'),
                    ),

                    const SizedBox(width: 25),

                    //English icon
                    GestureDetector(
                      onTap: () => const (Locale('en'),),
                      child: const RoundTile(
                          imagePath: 'lib/assets/images/Flag_of_the_United_Kingdom.png'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
