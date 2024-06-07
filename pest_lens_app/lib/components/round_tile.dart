import 'package:flutter/material.dart';

class RoundTile extends StatelessWidget {
  final String imagePath;

  const RoundTile({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      width: 24,
      height: 24,
    );
  }
}
