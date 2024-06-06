import 'user.dart';

class Admin extends User {
  Admin({
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.profileImageUrl,
    required super.farmName,
    required super.phoneNumber,
  });

  // Method to create an Admin object from a JSON object
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
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
