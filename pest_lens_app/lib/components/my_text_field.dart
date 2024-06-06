import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';

//How to call!
// const MyTextField(
//   prefixIcon: Icon(Icons.email, color: Colors.grey),
//   hintText: 'Enter your email',
// )
// const MyTextField()

class MyTextField extends StatelessWidget {
  final Icon? prefixIcon;
  final String? hintText;

  const MyTextField({super.key, this.prefixIcon, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextField(
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
