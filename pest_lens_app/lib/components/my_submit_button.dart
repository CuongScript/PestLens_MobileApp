import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';

class MySubmitButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;

  const MySubmitButton(
      {super.key, required this.onTap, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(17),
        margin: const EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
          color: submitButton,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: CustomTextStyles.submitButton,
          ),
        ),
      ),
    );
  }
}
