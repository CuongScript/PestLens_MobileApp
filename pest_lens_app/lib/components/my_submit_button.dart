import 'package:flutter/material.dart';

class MySubmitButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;

  const MySubmitButton({
    super.key,
    required this.onTap,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        onPressed: onTap,
        child: Center(
          child: Text(
            buttonText,
          ),
        ),
      ),
    );
  }
}
