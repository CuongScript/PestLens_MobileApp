import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pest_lens_app/components/insect_listview.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/upload_image_display.dart';
import 'package:pest_lens_app/models/insect_model.dart';

class InsectLookupResultPage extends StatefulWidget {
  final String objectKey;
  final List<Insect> insects;
  final String timestamp;

  const InsectLookupResultPage({
    super.key,
    required this.objectKey,
    required this.insects,
    required this.timestamp,
  });

  @override
  State<StatefulWidget> createState() => _InsectLookupResultPageState();
}

class _InsectLookupResultPageState extends State<InsectLookupResultPage> {
  String formatTimestamp(String timestamp) {
    // Parse the timestamp string
    DateTime dateTime = DateTime.parse(
      '${timestamp.substring(0, 8)}T${timestamp.substring(9)}',
    );

    // Format the date and time
    return DateFormat('MMMM d, yyyy \'at\' HH:mm:ss').format(dateTime);
  }

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
              child: UploadImageDisplay(objectKey: widget.objectKey),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    formatTimestamp(widget.timestamp),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: InsectListView(insects: widget.insects),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
