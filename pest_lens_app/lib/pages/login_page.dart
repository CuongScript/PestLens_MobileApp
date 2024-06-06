import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/my_text_field.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/components/round_tile.dart';

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
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
              ),

              const SizedBox(
                height: 13,
              ),

              // Password textfield
              MyTextField(
                controller: passwordController,
                obscureText: true, //Hide typed text
                prefixIcon: const Icon(Icons.lock, color: Colors.black),
                hintText: 'Password',
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
              ),

              // Sign up button
              // Sign in button
              MySubmitButton(
                onTap: signUserUp,
              ),

              const SizedBox(
                height: 50,
              ),

              // Viet+Eng icon button
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Vietnam icon
                  RoundTile(imagePath: 'lib/assets/images/Flag_of_Vietnam.png'),

                  SizedBox(width: 25),

                  //English icon
                  RoundTile(imagePath: 'lib/assets/images/Flag_of_the_United_Kingdom.png'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
