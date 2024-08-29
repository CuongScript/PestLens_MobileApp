import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pest_lens_app/utils/config.dart';
import 'package:pest_lens_app/models/insect_information_model.dart';
import 'package:pest_lens_app/preferences/user_preferences.dart';
import 'package:pest_lens_app/preferences/insect_information_preferences.dart';

class InsectInformationService {
  static const String _baseUrl = '${Config.apiUrl}/api/pests';
  static const String _googleSearchApiUrl = Config.googleSearchAPIUrl;

  Future<List<InsectInformationModel>> fetchInsectInformation() async {
    if (await InsectInformationPreferences.shouldFetchInsects()) {
      return _fetchFromApiAndCache();
    } else {
      final cachedInsects = await InsectInformationPreferences.getInsects();
      return cachedInsects ?? [];
    }
  }

  Future<List<InsectInformationModel>> _fetchFromApiAndCache() async {
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

      // Cache the fetched insects
      await InsectInformationPreferences.saveInsects(insects);

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
    // Try to get from preferences first
    final cachedInsect =
        await InsectInformationPreferences.getInsect(insectName);
    if (cachedInsect != null) {
      return cachedInsect;
    }

    // If not in preferences, fetch from API
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
      }

      // Update the cached insects with this new information
      final cachedInsects =
          await InsectInformationPreferences.getInsects() ?? [];
      final updatedInsects = cachedInsects
          .map((cached) => cached.englishName == insectName ? insect : cached)
          .toList();
      if (!updatedInsects.any((i) => i.englishName == insectName)) {
        updatedInsects.add(insect);
      }
      await InsectInformationPreferences.saveInsects(updatedInsects);

      return insect;
    } else {
      throw Exception('Failed to load insect details: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchInsectImages(String insectName) async {
    // Try to get from preferences first
    final cachedInsect =
        await InsectInformationPreferences.getInsect(insectName);
    if (cachedInsect != null && cachedInsect.imageUrls.isNotEmpty) {
      return cachedInsect.imageUrls;
    }

    // If not in preferences or no images, fetch from API
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
        final images =
            List<String>.from(data['images'].map((img) => img['imageUrl']));

        // Update the cached insect with these new images
        if (cachedInsect != null) {
          final cachedInsects =
              await InsectInformationPreferences.getInsects() ?? [];
          final updatedInsects = cachedInsects
              .map((cached) => cached.englishName == insectName
                  ? cached.copyWith(imageUrls: images)
                  : cached)
              .toList();
          await InsectInformationPreferences.saveInsects(updatedInsects);
        }

        return images;
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
