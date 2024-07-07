import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:pest_lens_app/pages/farmer/insect_lookup_result_page.dart';

class InsectLookupPage extends StatefulWidget {
  const InsectLookupPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InsectLookupPageState();
  }
}

class _InsectLookupPageState extends State<InsectLookupPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _submitSelectedImage(BuildContext context) {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No image selected'),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InsectLookupResultPage(imageFile: _image!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instant Insect Lookup"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Center(child: Text("No image selected")),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImageFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text("Upload Image from Gallery"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Take a Photo"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
                onPressed: () => _submitSelectedImage(context),
                icon: const Icon(Icons.search),
                label: const Text("Identify Insect"))
          ],
        ),
      ),
    );
  }
}
