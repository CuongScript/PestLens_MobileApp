import 'package:flutter/material.dart';
import 'package:pest_lens_app/components/insect_listview.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/upload_image_display.dart';
import 'dart:io';

import 'package:pest_lens_app/models/insect_model.dart';

class InsectLookupResultPage extends StatefulWidget {
  final File imageFile;
  final List<Insect> insects;

  const InsectLookupResultPage({
    super.key,
    required this.imageFile,
    required this.insects,
  });

  @override
  State<StatefulWidget> createState() => _InsectLookupResultPageState();
}

class _InsectLookupResultPageState extends State<InsectLookupResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Count Result', style: CustomTextStyles.pageTitle),
        leading: IconButton(
          icon: const MyBackButton(),
          onPressed: () => Navigator.of(context).pop(),
        ),
        leadingWidth: 45,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: UploadImageDisplay(imageFile: widget.imageFile),
            ),
          ),
          // Lower half: List of insects
          Expanded(
            flex: 1,
            child: InsectListView(insects: widget.insects),
          ),
        ],
      ),
    );
  }
}
