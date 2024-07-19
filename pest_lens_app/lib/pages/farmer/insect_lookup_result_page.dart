import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pest_lens_app/dummy/insect_dummy_data.dart';

class InsectLookupResultPage extends StatefulWidget {
  const InsectLookupResultPage({super.key, required this.imageFile});

  final File imageFile;

  @override
  State<StatefulWidget> createState() {
    return _InsectLookupResultPageState();
  }
}

class _InsectLookupResultPageState extends State<InsectLookupResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insect Detection Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Upper half: Image display
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: Image.file(
                widget.imageFile,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Lower half: List of insects
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: insectDetections.length,
              itemBuilder: (context, index) {
                final insect = insectDetections[index];
                return Card(
                  color: Colors.lightBlue.shade100,
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: ListTile(
                    leading: const Icon(Icons.bug_report, color: Colors.black),
                    title: Text(insect['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text(
                      insect['count']!,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
