import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/services/s3_service.dart';

class ProfileImagePicker extends StatefulWidget {
  final String? imageUrl;
  final bool isReadOnly;
  final Function(File)? onImagePicked;

  const ProfileImagePicker({
    Key? key,
    this.imageUrl,
    this.isReadOnly = false,
    this.onImagePicked,
  }) : super(key: key);

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isReadOnly ? null : _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipOval(
            child: SizedBox(
              width: 120,
              height: 120,
              child: _buildImageContent(),
            ),
          ),
          if (!widget.isReadOnly)
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: appNameColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    if (_imageFile != null) {
      return Image.file(
        _imageFile!,
        fit: BoxFit.cover,
      );
    }

    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return _buildPlaceholderImage();
    }

    if (Uri.tryParse(widget.imageUrl!)?.hasScheme ?? false) {
      return _buildNetworkImage(widget.imageUrl!);
    } else {
      return _buildS3Image(widget.imageUrl!);
    }
  }

  Widget _buildPlaceholderImage() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey[300],
      child: const ClipOval(
        child: Icon(
          Icons.face_rounded,
          size: 60,
        ),
      ),
    );
  }

  Widget _buildNetworkImage(String url) {
    return FadeInImage.assetNetwork(
      placeholder: 'lib/assets/images/placeholder_profile_image.png',
      image: url,
      fit: BoxFit.cover,
      imageErrorBuilder: (context, error, stackTrace) {
        return _buildPlaceholderImage();
      },
    );
  }

  Widget _buildS3Image(String objectKey) {
    return FutureBuilder<Uint8List>(
      future: S3Service().getUserProfileImageData(objectKey),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
          );
        } else if (snapshot.hasError) {
          return _buildPlaceholderImage();
        } else {
          return _buildPlaceholderImage();
        }
      },
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      widget.onImagePicked?.call(_imageFile!);
    }
  }
}
