import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pest_lens_app/utils/config.dart';
import 'package:pest_lens_app/models/insect_information_model.dart';
import 'package:pest_lens_app/utils/user_preferences.dart';

class InsectInformationService {
  static const String _baseUrl = '${Config.apiUrl}/api/pests';
  static const String _googleSearchApiUrl = Config.googleSearchAPiUrl;

  Future<List<InsectInformationModel>> fetchInsectInformation() async {
    final user = await UserPreferences.getUser();

    final response = await http.get(Uri.parse(_baseUrl), headers: {
      'Authorization': '${user!.tokenType} ${user.accessToken}',
    });

    if (response.statusCode == 200) {
      final List<dynamic> insectsJson = jsonDecode(response.body);
      List<InsectInformationModel> insects = insectsJson
          .map((json) => InsectInformationModel.fromJson(json))
          .where((insect) => insect.englishName.toLowerCase() != "unidentified")
          .toList();

      // Fetch images for all insects concurrently
      await Future.wait(
        insects.map((insect) => _fetchAndSetImages(insect)),
      );

      return insects;
    } else {
      throw Exception('Failed to load insects');
    }
  }

  Future<void> _fetchAndSetImages(InsectInformationModel insect) async {
    try {
      List<String> imageUrls = await fetchInsectImages(insect.englishName);
      insect.imageUrls = imageUrls;
    } catch (e) {
      print('Error fetching images for ${insect.englishName}: $e');
    }
  }

  Future<InsectInformationModel> fetchInsectDetails(String insectName) async {
    final user = await UserPreferences.getUser();
    final encodedName = Uri.encodeComponent(insectName);
    final url = '$_baseUrl/name/$encodedName';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': '${user!.tokenType} ${user.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final insectJson = jsonDecode(response.body);
      InsectInformationModel insect =
          InsectInformationModel.fromJson(insectJson);

      // Fetch images for the insect
      try {
        List<String> imageUrls = await fetchInsectImages(insect.englishName);
        insect.imageUrls = imageUrls;
      } catch (e) {
        print('Error fetching images for ${insect.englishName}: $e');
        // If image fetch fails, just leave the imageUrls empty
      }

      return insect;
    } else {
      throw Exception('Failed to load insect details: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchInsectImages(String insectName) async {
    try {
      final response = await http.get(
        Uri.parse('$_googleSearchApiUrl?q=$insectName&num=10'),
        headers: {
          'X-API-KEY': Config.googleSearchAPIKey,
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['images'].map((img) => img['imageUrl']));
      } else {
        print('Failed to load images for $insectName: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching images for $insectName: $e');
      return [];
    }
  }
}
