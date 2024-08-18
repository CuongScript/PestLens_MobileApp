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
          .toList();

      // Fetch images for each insect
      for (var insect in insects) {
        try {
          List<String> imageUrls = await fetchInsectImages(insect.englishName);
          insect.imageUrls = imageUrls;
        } catch (e) {
          print('Error fetching images for ${insect.englishName}: $e');
          // If image fetch fails, just leave the imageUrls empty
        }
      }

      return insects;
    } else {
      throw Exception('Failed to load insects');
    }
  }

  Future<List<String>> fetchInsectImages(String insectName) async {
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
      throw Exception('Failed to load images for $insectName');
    }
  }
}
