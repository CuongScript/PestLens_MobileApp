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
      List<InsectInformationModel> insectList = insectJsonList
          .map((insectJson) =>
              InsectInformationModel.fromJson(jsonDecode(insectJson)))
          .toList();

      return insectList;
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

  static Future<bool> shouldFetchInsects() async {
    final lastFetchTime = await getLastFetchTime();
    if (lastFetchTime == null) return true;

    final currentTime = DateTime.now();
    final difference = currentTime.difference(lastFetchTime);

    // Fetch new data if it's been more than 24 hours since the last fetch
    return difference.inHours > 100;
  }

  //get a specific insect's information
  static Future<InsectInformationModel?> getInsect(String insectName) async {
    final insects = await getInsects();
    if (insects == null || insects.isEmpty) {
      return null;
    }
    try {
      return insects.firstWhere((insect) => insect.englishName == insectName);
    } catch (e) {
      return null;
    }
  }
}
