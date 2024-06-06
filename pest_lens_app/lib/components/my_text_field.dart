import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';

//How to call!
// const MyTextField(prefixIcon: Icon(Icons.email, color: Colors.grey),)
// const MyTextField()

class MyTextField extends StatelessWidget {
  final Icon? prefixIcon;

  const MyTextField({super.key, this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
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
