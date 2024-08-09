import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pest_lens_app/pages/farmer/image_full_screen_page.dart';

class UploadImageDisplay extends StatelessWidget {
  final File imageFile;

  const UploadImageDisplay({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.fullscreen, color: Colors.white),
              iconSize: 32, // Increased icon size
              padding: const EdgeInsets.all(12), // Increased padding
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ImageFullScreenPage(imageFile: imageFile),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}