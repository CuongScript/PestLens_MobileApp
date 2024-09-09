class InsectAlertModel {
  final String englishName;
  final String vietnameseName;
  final double percentageIncrease;
  final DateTime startDate;
  final DateTime endDate;
  final String alertMessage;
  final int currentCount;
  final int previousCount;

  InsectAlertModel({
    required this.englishName,
    required this.vietnameseName,
    required this.percentageIncrease,
    required this.startDate,
    required this.endDate,
    required this.alertMessage,
    required this.currentCount,
    required this.previousCount,
  });

  factory InsectAlertModel.fromJson(Map<String, dynamic> json) {
    return InsectAlertModel(
      englishName: json['pest']['englishName'],
      vietnameseName: json['pest']['vietnameseName'],
      percentageIncrease: json['percentageIncrease'],
      startDate:
          DateTime.fromMillisecondsSinceEpoch(json['startDate']['value']),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate']['value']),
      alertMessage: json['alertMessage'],
      currentCount: json['currentCount'],
      previousCount: json['previousCount'],
    );
  }
}
