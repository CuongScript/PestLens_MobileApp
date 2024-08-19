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
      imageUrls: (json['imageUrls'] as List<dynamic>?)?.cast<String>() ?? [],
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

  InsectInformationModel copyWith({
    int? id,
    String? englishName,
    String? vietnameseName,
    String? scientificName,
    String? size,
    String? habit,
    String? behaviour,
    String? impact,
    String? insectType,
    List<String>? imageUrls,
  }) {
    return InsectInformationModel(
      id: id ?? this.id,
      englishName: englishName ?? this.englishName,
      vietnameseName: vietnameseName ?? this.vietnameseName,
      scientificName: scientificName ?? this.scientificName,
      size: size ?? this.size,
      habit: habit ?? this.habit,
      behaviour: behaviour ?? this.behaviour,
      impact: impact ?? this.impact,
      insectType: insectType ?? this.insectType,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}
