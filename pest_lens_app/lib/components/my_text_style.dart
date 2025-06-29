import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';

class CustomTextStyles {
  static const TextStyle appName = TextStyle(
    fontFamily: 'Inter',
    fontSize: 30,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
    height: 1.2,
    color: appNameColor,
  );

  static const TextStyle pageTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: fontTitleColor,
  );

  static const TextStyle pageTitle2 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: fontTitleColor,
  );

  static const TextStyle cameraErrorMessage = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: Colors.red,
  );

  static const TextStyle hintTextField = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: Colors.black,
    letterSpacing: 0.105,
  );

  static const TextStyle labelTextField = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: Colors.black,
  );

  static const TextStyle labelTextErrorField = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: Colors.red,
  );

  static TextStyle forgotPass = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: Colors.grey.shade600,
  );

  static const TextStyle submitButton = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: primaryBackgroundColor,
    letterSpacing: 0.14,
  );

  static const TextStyle emailVerifyText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: Colors.black,
    letterSpacing: 0.14,
  );
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );
}
