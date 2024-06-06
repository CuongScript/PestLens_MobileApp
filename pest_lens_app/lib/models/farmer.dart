import "package:pest_lens_app/models/user.dart";

class Farmer extends User {
  Farmer({
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.profileImageUrl,
    required super.farmName,
    required super.phoneNumber,
  });

  // Method to create a Farmer object from a JSON object
  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profileImageUrl: json['profileImageUrl'],
      farmName: json['farmName'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
