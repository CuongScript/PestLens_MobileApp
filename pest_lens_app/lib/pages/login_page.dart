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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: textFieldBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade900,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 13,
              ),
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
