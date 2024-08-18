import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pest_lens_app/models/insect_information_model.dart';

class InsectInformationPreferences {
  static const String _insectDataKey = 'insectData';
  static const String _lastFetchTimeKey = 'lastInsectFetchTime';

  static Future<void> saveInsects(List<InsectInformationModel> insects) async {
    final prefs = await SharedPreferences.getInstance();
    final insectJsonList =
        insects.map((insect) => jsonEncode(insect.toJson())).toList();
    await prefs.setStringList(_insectDataKey, insectJsonList);
    await prefs.setInt(
        _lastFetchTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<List<InsectInformationModel>?> getInsects() async {
    final prefs = await SharedPreferences.getInstance();
    final insectJsonList = prefs.getStringList(_insectDataKey);

    if (insectJsonList != null) {
      return insectJsonList
          .map((insectJson) =>
              InsectInformationModel.fromJson(jsonDecode(insectJson)))
          .toList();
    }
    return null;
  }

  static Future<DateTime?> getLastFetchTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastFetchTime = prefs.getInt(_lastFetchTimeKey);

    if (lastFetchTime != null) {
      return DateTime.fromMillisecondsSinceEpoch(lastFetchTime);
    }
    return null;
  }

  static Future<void> clearInsectData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_insectDataKey);
    await prefs.remove(_lastFetchTimeKey);
  }

  static Future<void> saveInsectImages(
      String insectName, List<String> imageUrls) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('${insectName}Images', imageUrls);
  }

  static Future<List<String>?> getInsectImages(String insectName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('${insectName}Images');
  }

  static Future<bool> shouldFetchInsects() async {
    final lastFetchTime = await getLastFetchTime();
    if (lastFetchTime == null) return true;

    final currentTime = DateTime.now();
    final difference = currentTime.difference(lastFetchTime);

    // Fetch new data if it's been more than 24 hours since the last fetch
    return difference.inHours > 24;
  }
}
