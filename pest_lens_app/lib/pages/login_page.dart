import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor, // Use the color constant here
        appBar: AppBar(
          title: const Text('Primary Background Color Example'),
        ),
        body: const Center(
          child: Text('Hello, World!'),
        ),
      );
    // return Scaffold(
    //   backgroundColor: primaryBackgroundColor,
    //   body: SafeArea(
    //     child: Center(
    //       child: Column(
    //         children: const [
    //           const SizedBox(
    //             height: 50,
    //           ),
    //           // Logo
    //           const Icon(
    //             Icons.lock,
    //             size: 100,
    //           ),

    //           const SizedBox(
    //             height: 50,
    //           ),

    //           // App name

    //           // Username textfield

    //           // Password textfield

    //           // Forgot password

    //           // Sign in button

    //           // Sign up button

    //           // Viet+Eng icon button
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
