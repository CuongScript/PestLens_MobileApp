import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        color: appNameColor, // Background color of the circle
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.arrow_back_ios_outlined,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
