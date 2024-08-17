class InsectCountModel {
  DateTime date;
  String englishName;
  int count;
  String source;

  InsectCountModel({
    required this.date,
    required this.englishName,
    required this.count,
    this.source = '',
  });

  factory InsectCountModel.fromJson(Map<String, dynamic> json) {
    return InsectCountModel(
      date: DateTime.parse(json['date']),
      englishName: json['englishName'],
      count: json['count'],
      source: json['source'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'englishName': englishName,
      'count': count,
    };
  }

  @override
  String toString() {
    return 'InsectCountModel(date: $date, englishName: $englishName, count: $count)';
  }
}
