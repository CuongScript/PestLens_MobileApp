import 'package:flutter/material.dart';

class MySubmitButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final bool isFilled;
  final Color? filledColor;
  final String? iconPath; // New parameter for the icon path

  const MySubmitButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.isFilled,
    this.filledColor,
    this.iconPath, // Add this to the constructor
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconPath != null) ...[
              Image.asset(
                iconPath!,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 8), // Add some space between icon and text
            ],
            Text(
              buttonText,
              style: TextStyle(
                color: isFilled ? Colors.white : actualFilledColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
