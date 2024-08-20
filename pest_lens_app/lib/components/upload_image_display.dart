import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:pest_lens_app/pages/farmer/image_full_screen_page.dart';
import 'package:pest_lens_app/services/s3_service.dart';

class UploadImageDisplay extends StatefulWidget {
  final File? imageFile;
  final String? objectKey;

  const UploadImageDisplay({
    super.key,
    this.imageFile,
    this.objectKey,
  }) : assert(imageFile != null || objectKey != null);

  @override
  _UploadImageDisplayState createState() => _UploadImageDisplayState();
}

class _UploadImageDisplayState extends State<UploadImageDisplay> {
  late Future<Uint8List?> _imageFuture;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() {
    if (widget.imageFile != null) {
      _imageFuture = widget.imageFile!.readAsBytes().catchError((error) {
        print('Error reading local file: $error');
      });
    } else if (widget.objectKey != null) {
      _imageFuture =
          S3Service().getImageData(widget.objectKey!).catchError((error) {
        print('Error fetching image from S3: $error');
      });
    } else {
      _imageFuture = Future.value(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            (snapshot.hasData && snapshot.data == null)) {
          return _buildErrorWidget();
        } else if (snapshot.hasData && snapshot.data != null) {
          return _buildImageWidget(snapshot.data!);
        } else {
          return const Center(child: Text('No image data'));
        }
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Failed to load image',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _loadImage();
              });
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget(Uint8List imageData) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              imageData,
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
              iconSize: 32,
              padding: const EdgeInsets.all(12),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ImageFullScreenPage(
                      imageFile: widget.imageFile,
                      objectKey: widget.objectKey,
                    ),
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
