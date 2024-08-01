import 'package:flutter/material.dart';

class MySubmitButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final bool isFilled;

  const MySubmitButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.isFilled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isFilled ? const Color(0xFF0064C3) : Colors.white,
          foregroundColor: isFilled ? Colors.white : const Color(0xFF0064C3),
          side: const BorderSide(color: Color(0xFF0064C3), width: 2),
        ),
        onPressed: onTap,
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: isFilled ? Colors.white : const Color(0xFF0064C3),
            ),
          ),
        ),
      ),
    );
  }
}
