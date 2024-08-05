import 'package:pest_lens_app/models/account_status_enum.dart';
import 'package:pest_lens_app/models/role_enum.dart';

class UserFullInfoModel {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final Role roles;
  final AccountStatusEnum status;

  // Constructor
  UserFullInfoModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.avatarUrl,
    required this.createdAt,
    this.lastLogin,
    required this.roles,
    required this.status,
  });

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'roles': roles.toJson(),
      'status': status.toString().split('.').last,
    };
  }

  // Factory method to create an instance from JSON
  factory UserFullInfoModel.fromJson(Map<String, dynamic> json) {
    return UserFullInfoModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      avatarUrl: json['avatarUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLogin:
          json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      roles: RoleExtension.fromString(json['roles']),
      status: AccountStatusEnum.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => throw Exception('Unknown status: ${json['status']}'),
      ),
    );
  }
}
