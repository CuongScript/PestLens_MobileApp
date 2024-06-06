import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';

//How to call!
// MyTextField(
//   controller: passwordController,
//   obscureText: true, //Hide typed text
//   prefixIcon: const Icon(Icons.lock, color: Colors.black),
//   hintText: 'Password',
// )
// const MyTextField()

class MyTextField extends StatelessWidget {
  final controller;
  final bool obscureText;
  final Icon? prefixIcon;
  final String? hintText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    this.prefixIcon,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: CustomTextStyles.hintTextField,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: textFieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.grey.shade900,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
