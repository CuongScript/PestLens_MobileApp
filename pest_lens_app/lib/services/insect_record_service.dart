import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pest_lens_app/models/insect_count_model.dart';
import 'package:pest_lens_app/models/insect_model.dart';
import 'package:pest_lens_app/preferences/user_preferences.dart';
import 'package:pest_lens_app/utils/config.dart';
import 'package:pest_lens_app/models/insect_alert_model.dart';

class InsectRecordService {
  static const String baseUrl = '${Config.apiUrl}/api';

  Future<List<InsectCountModel>> fetchInsectDataRecords(
      DateTime startDate, DateTime endDate) async {
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    final formattedStartDate = formatter.format(startDate);
    final formattedEndDate = formatter.format(endDate);
    final url = Uri.parse(
        '$baseUrl/pest-data/date?startDate=$formattedStartDate&endDate=$formattedEndDate');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => InsectCountModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load insect data ${response.body}');
      }
    } catch (e) {
      return [];
    }
  }

  List<Insect> processInsectData(List<InsectCountModel> data) {
    Map<String, int> totalCounts = {};

    for (var insect in data) {
      totalCounts[insect.englishName] =
          (totalCounts[insect.englishName] ?? 0) + insect.count;
    }

    return totalCounts.entries.map((entry) {
      return Insect(
        name: entry.key,
        color: getInsectColor(entry.key),
        quantity: entry.value,
      );
    }).toList();
  }

  Color getInsectColor(String insectName) {
    final colorMap = {
      'Leaf Rollers': Colors.green,
      'Brown Plant Hopper': Colors.brown,
      'Rice Asian Gall Midge': Colors.orange,
      'Stem Borers': Colors.purple,
      'Thrips': Colors.red,
      'unidentified': Colors.grey,
    };

    return colorMap[insectName] ?? Colors.blue;
  }

  List<Map<String, dynamic>> calculateInsectTotalsByDate(
      List<InsectCountModel> data) {
    Map<String, Map<String, int>> dailyTotals = {};

    for (var insect in data) {
      String dateKey = DateFormat('yyyy-MM-dd').format(insect.date.toLocal());
      dailyTotals.putIfAbsent(dateKey, () => {});
      dailyTotals[dateKey]![insect.englishName] =
          (dailyTotals[dateKey]![insect.englishName] ?? 0) + insect.count;
    }

    List<Map<String, dynamic>> result = [];
    dailyTotals.forEach((date, counts) {
      Map<String, dynamic> entry = {'date': DateTime.parse(date)};
      entry.addAll(counts);
      result.add(entry);
    });

    return result
      ..sort(
          (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
  }

  List<Map<String, dynamic>> calculateInsectTotalsByHour(
      List<InsectCountModel> data) {
    Map<int, Map<String, int>> hourlyTotals = {};

    for (var insect in data) {
      int hour = insect.date.hour;
      hourlyTotals.putIfAbsent(hour, () => {});
      hourlyTotals[hour]![insect.englishName] =
          (hourlyTotals[hour]![insect.englishName] ?? 0) + insect.count;
    }

    List<Map<String, dynamic>> result = [];
    for (int hour = 0; hour <= 24; hour++) {
      Map<String, dynamic> entry = {
        'hour': '${hour.toString().padLeft(2, '0')}:00',
      };
      entry.addAll(hourlyTotals[hour] ?? {});
      result.add(entry);
    }

    return result;
  }

  List<Map<String, dynamic>> calculateInsectTotalByType(
      List<InsectCountModel> data, DateTime startDate, DateTime endDate) {
    Map<String, int> totalCounts = {};

    for (var insect in data) {
      if (insect.date.isAfter(startDate) && insect.date.isBefore(endDate)) {
        totalCounts[insect.englishName] =
            (totalCounts[insect.englishName] ?? 0) + insect.count;
      }
    }

    List<Map<String, dynamic>> result = [];
    totalCounts.forEach((insectName, count) {
      result.add({
        'insectType': insectName,
        'count': count,
      });
    });

    return result
      ..sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
  }

  Future<List<InsectAlertModel>> fetchInsectAlerts(
      {int days = 6, double threshold = 1}) async {
    final user = await UserPreferences.getUser();
    final url =
        Uri.parse('$baseUrl/pest-data/alerts?days=$days&threshold=$threshold');
    final headers = {
      'Authorization': 'Bearer ${user?.accessToken}',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => InsectAlertModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load insect alerts: ${response.body}');
      }
    } catch (e) {
      print('Error fetching insect alerts: $e');
      return [];
    }
  }
}
