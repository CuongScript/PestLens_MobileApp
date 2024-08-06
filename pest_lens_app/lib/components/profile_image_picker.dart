import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatefulWidget {
  final String? imageUrl;
  final bool isReadOnly;

  const ProfileImagePicker({
    super.key,
    this.imageUrl,
    this.isReadOnly = false,
  });

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  ImageProvider? _image;

  @override
  void initState() {
    super.initState();
    _setImage(widget.imageUrl);
  }

  void _setImage(String? url) {
    if (url != null && url.isNotEmpty) {
      _image = NetworkImage(url);
    } else {
      _image =
          const AssetImage('lib/assets/images/placeholder_profile_image.png');
    }
  }

  void _pickImage() async {
    if (widget.isReadOnly) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = FileImage(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isReadOnly ? null : _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: _image,
          ),
          if (!widget.isReadOnly)
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
