import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pest_lens_app/models/insect_model.dart';
import 'package:pest_lens_app/utils/config.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class FarmerService {
  static const String baseUrl = Config.mlAPIUrl;

  Future<Map<String, dynamic>> detectInsects(File imageFile) async {
    var uri = Uri.parse('$baseUrl/detect');
    var request = http.MultipartRequest('POST', uri);

    // Determine the content type based on the file extension
    String extension = path.extension(imageFile.path).toLowerCase();
    String contentType;
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        contentType = 'image/jpeg';
        break;
      case '.png':
        contentType = 'image/png';
        break;
      default:
        throw Exception('Unsupported image type: $extension');
    }

    // Add the file to the request with the correct content type
    var multipartFile = await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
      contentType: MediaType.parse(contentType),
    );
    request.files.add(multipartFile);

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception(
            'Failed to detect insects: ${response.statusCode} ${response.reasonPhrase}\nBody: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during insect detection: $e');
    }
  }

  // Convert JSON response to list of Insect objects
  List<Insect> parseInsects(Map<String, dynamic> jsonResponse) {
    var insectCounts = jsonResponse['insect_counts'] as Map<String, dynamic>;

    // Define color mapping
    final colorMap = {
      'Leaf Rollers': Colors.green,
      'Brown Plant Hopper': Colors.brown,
      'Rice Asian Gall Midge': Colors.orange,
      'Stem Borers': Colors.purple,
      'Thrips': Colors.red,
      'unidentified': Colors.grey,
    };

    return insectCounts.entries.map((entry) {
      String name = entry.key.toLowerCase();

      return Insect(
        name: name,
        color: colorMap[name.toLowerCase()] ??
            Colors.blue, // Default to blue if not found
        quantity: entry.value as int,
      );
    }).toList();
  }

  String getOutputImagePath(Map<String, dynamic> jsonResponse) {
    return jsonResponse['output_image_path'] as String;
  }

  String getTimestamp(Map<String, dynamic> jsonResponse) {
    return jsonResponse['timestamp'] as String;
  }
}
