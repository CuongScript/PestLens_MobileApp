import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/upload_image_display.dart';
import 'package:pest_lens_app/models/insect_model.dart';
import 'package:pest_lens_app/services/famer_service.dart';
import 'package:pest_lens_app/pages/farmer/insect_lookup_result_page.dart';
import 'dart:io';

class InsectLookupPage extends StatefulWidget {
  const InsectLookupPage({super.key});

  @override
  State<InsectLookupPage> createState() => _InsectLookupPageState();
}

class _InsectLookupPageState extends State<InsectLookupPage> {
  final ImagePicker _picker = ImagePicker();
  final FarmerService _farmerService = FarmerService();
  File? _image;
  bool _isLoading = false;

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

  Future<void> _detectInsects() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await _farmerService.detectInsects(_image!);

      // Check if the widget is still mounted before proceeding
      if (!mounted) return;

      List<Insect> insects =
          _farmerService.parseInsects(response).cast<Insect>();

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InsectLookupResultPage(
            imageFile: _image!,
            insects: insects,
          ),
        ),
      );
    } catch (e) {
      // Check if the widget is still mounted before showing SnackBar
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to detect insects: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildImageSourceButton(
      String label, IconData icon, VoidCallback onPressed) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: const Color(0xFF0064c3)),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(color: Color(0xFF0064c3))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Insect Lookup', style: CustomTextStyles.pageTitle),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Center the insect in the image\nEnsure the insect is clearly focused',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: _pickImageFromGallery,
                      child: _buildImageSourceButton(
                          'Photos', Icons.photo_library, _pickImageFromGallery),
                    ),
                    GestureDetector(
                      onTap: _takePhoto,
                      child: _buildImageSourceButton(
                          'Camera', Icons.camera_alt, _takePhoto),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_image != null)
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: UploadImageDisplay(imageFile: _image!),
                    ),
                  ),
                const SizedBox(height: 20),
                MySubmitButton(
                  onTap: _image != null ? _detectInsects : null,
                  buttonText: "Identify Insect",
                  isFilled: true,
                  filledColor: const Color(0xFF0064C3),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
