import 'package:flutter/material.dart';

class MySubmitButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final bool isFilled;
  final Color? filledColor;

  const MySubmitButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.isFilled,
    this.filledColor,
  });

  @override
  Widget build(BuildContext context) {
    const Color defaultColor = Color(0xFF0064C3);
    final Color actualFilledColor = filledColor ?? defaultColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isFilled ? actualFilledColor : Colors.white,
          foregroundColor: isFilled ? Colors.white : actualFilledColor,
          side: BorderSide(color: actualFilledColor, width: 2),
        ),
        onPressed: onTap,
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: isFilled ? Colors.white : actualFilledColor,
            ),
          ),
        ),
      ),
    );
  }
}
