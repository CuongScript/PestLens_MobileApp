import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/text_style.dart';

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
                child: Image.asset('lib/assets/images/appIcon.png', ),
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

              // Password textfield

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
