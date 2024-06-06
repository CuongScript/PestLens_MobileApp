import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/my_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 201,
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
              const MyTextField(prefixIcon: Icon(Icons.email, color: Colors.grey),),

              const SizedBox(
                height: 13,
              ),
              // Password textfield
              const MyTextField(),

              // Forgot password

              // Sign in button

              // Sign up button

              // Viet+Eng icon button
            ],
          ),
        ),
      ),
    );
  }
}
