import 'package:flutter/material.dart';

class CenterTextPainter extends CustomPainter {
  final String text;
  final double centerX;
  final double centerY;

  CenterTextPainter(
      {required this.text, required this.centerX, required this.centerY});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final offset = Offset(
      centerX - textPainter.width / 2,
      centerY - textPainter.height / 2,
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
