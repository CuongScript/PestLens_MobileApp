class InsectInformationModel {
  final int id;
  final String englishName;
  final String vietnameseName;
  final String scientificName;
  final String size;
  final String habit;
  final String behaviour;
  final String impact;
  final String insectType;
  List<String> imageUrls;

  InsectInformationModel({
    required this.id,
    required this.englishName,
    required this.vietnameseName,
    required this.scientificName,
    required this.size,
    required this.habit,
    required this.behaviour,
    required this.impact,
    required this.insectType,
    this.imageUrls = const [],
  });

  factory InsectInformationModel.fromJson(Map<String, dynamic> json) {
    return InsectInformationModel(
      id: json['id'],
      englishName: json['englishName'],
      vietnameseName: json['vietnameseName'],
      scientificName: json['scientificName'],
      size: json['size'],
      habit: json['habit'],
      behaviour: json['behaviour'],
      impact: json['impact'],
      insectType: json['insectType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'englishName': englishName,
      'vietnameseName': vietnameseName,
      'scientificName': scientificName,
      'size': size,
      'habit': habit,
      'behaviour': behaviour,
      'impact': impact,
      'insectType': insectType,
      'imageUrls': imageUrls,
    };
  }
}
