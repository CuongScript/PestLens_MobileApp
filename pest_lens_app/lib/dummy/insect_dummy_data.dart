import 'package:pest_lens_app/models/insect_count_model.dart';

const List<Map<String, String>> insectDetections = [
  {"name": "Rice Asian Gall Midge", "count": "5"},
  {"name": "Stem Borers", "count": "3"},
  {"name": "Thrips", "count": "7"},
  {"name": "Unidentified insect", "count": "2"},
  {"name": "Brown Planthopper", "count": "4"},
  {"name": "Green Leafhopper", "count": "6"},
  {"name": "Yellow Stem Borer", "count": "8"},
  {"name": "Whitefly", "count": "9"},
  {"name": "Armyworm", "count": "11"},
  {"name": "Leaf Miner", "count": "10"},
  {"name": "Cutworm", "count": "5"},
  {"name": "Red Spider Mite", "count": "12"},
  {"name": "Rice Water Weevil", "count": "7"},
  {"name": "Rice Root Aphid", "count": "3"},
];

List<InsectCountModel> dummyInsectCountList = [
  InsectCountModel(
    date: DateTime.now(),
    englishName: 'Brown Planthopper',
    count: 34,
  ),
  // Today
  InsectCountModel(
    date: DateTime.now(),
    englishName: 'Stem Borers',
    count: 45,
  ),
  InsectCountModel(
    date: DateTime.now(),
    englishName: 'Leaf Rollers',
    count: 56,
  ),
  InsectCountModel(
    date: DateTime.now(),
    englishName: 'Rice Asian Gall Midge',
    count: 23,
  ),
  InsectCountModel(
    date: DateTime.now(),
    englishName: 'Thrips',
    count: 1000,
  ),
  InsectCountModel(
    date: DateTime.now(),
    englishName: 'Unidentify',
    count: 78,
  ),
  // 1 day ago
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 1)),
    englishName: 'Brown Planthopper',
    count: 34,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 1)),
    englishName: 'Stem Borers',
    count: 45,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 1)),
    englishName: 'Leaf Rollers',
    count: 56,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 1)),
    englishName: 'Rice Asian Gall Midge',
    count: 23,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 1)),
    englishName: 'Thrips',
    count: 67,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 1)),
    englishName: 'Unidentify',
    count: 78,
  ),
  // 2 days ago
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 2)),
    englishName: 'Brown Planthopper',
    count: 34,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 2)),
    englishName: 'Stem Borers',
    count: 45,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 2)),
    englishName: 'Leaf Rollers',
    count: 56,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 2)),
    englishName: 'Rice Asian Gall Midge',
    count: 23,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 2)),
    englishName: 'Thrips',
    count: 67,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 2)),
    englishName: 'Unidentify',
    count: 78,
  ),
  // 3 days ago
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 3)),
    englishName: 'Brown Planthopper',
    count: 34,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 3)),
    englishName: 'Stem Borers',
    count: 45,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 3)),
    englishName: 'Leaf Rollers',
    count: 56,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 3)),
    englishName: 'Rice Asian Gall Midge',
    count: 23,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 3)),
    englishName: 'Thrips',
    count: 0,
  ),
  InsectCountModel(
    date: DateTime.now().subtract(const Duration(days: 3)),
    englishName: 'Unidentify',
    count: 2,
  ),
];
