import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';

class CustomTextStyles {
  static const TextStyle appName = TextStyle(
    fontFamily: 'Inter',
    fontSize: 30,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
    height: 1.0,
    color: appNameColor,
  );

  static const TextStyle hintTextField = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 1.0,
    color: Colors.black,
    letterSpacing: 0.105,
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
