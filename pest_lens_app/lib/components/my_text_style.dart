import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';

class CustomTextStyles {
  static const TextStyle appName = TextStyle(
    fontFamily: 'Inter', // Font family
    fontSize: 30, // Font size
    fontStyle: FontStyle.normal, // Font style
    fontWeight: FontWeight.w800, // Font weight
    height: 1.0, // Line height
    color: appNameColor,
  );

  static const TextStyle pageTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: fontTitleColor,
  );

  // Add more text styles as needed
  // static const TextStyle appName = TextStyle(
  //   fontFamily: 'Inter', // Font family
  //   fontSize: 30, // Font size
  //   fontStyle: FontStyle.normal, // Font style
  //   fontWeight: FontWeight.w800, // Font weight
  //   height: 1.0, // Line height
  //   color: appNameColor,
  // );
}
