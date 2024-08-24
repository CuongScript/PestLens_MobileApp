import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:pest_lens_app/services/s3_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageFullScreenPage extends StatelessWidget {
  final File? imageFile;
  final String? objectKey;

  const ImageFullScreenPage({
    Key? key,
    this.imageFile,
    this.objectKey,
  })  : assert(imageFile != null || objectKey != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Uint8List?>(
        future: _getImageData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    '${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            return Center(
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(80),
                minScale: 0.5,
                maxScale: 4,
                child: Image.memory(
                  snapshot.data!,
                  fit: BoxFit.contain,
                ),
              ),
            );
          } else {
            return Center(child: Text(AppLocalizations.of(context)!.noImgData));
          }
        },
      ),
    );
  }

  Future<Uint8List?> _getImageData() async {
    if (imageFile != null) {
      return await imageFile!.readAsBytes();
    } else if (objectKey != null) {
      return await S3Service().getImageData(objectKey!);
    }
    return null;
  }
}
