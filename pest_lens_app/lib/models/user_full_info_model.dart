import 'package:pest_lens_app/models/account_status_enum.dart';
import 'package:pest_lens_app/models/role_enum.dart';

class UserFullInfoModel {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final DateTime? activatedAt;
  final List<Role> roles;
  final AccountStatusEnum accountStatus;
  final bool inactiveUser;
  final bool newUser;

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
    this.activatedAt,
    required this.roles,
    required this.accountStatus,
    required this.inactiveUser,
    required this.newUser,
  });

  factory UserFullInfoModel.fromJson(Map<String, dynamic> json) {
    return UserFullInfoModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      avatarUrl: json['avatarUrl'],
      createdAt: _parseDateTime(json['createdAt']),
      lastLogin: _parseDateTime(json['lastLogin']),
      activatedAt: _parseDateTime(json['activatedAt']),
      roles: (json['roles'] as List<dynamic>)
          .map((roleJson) => RoleExtension.fromJson(roleJson))
          .toList(),
      accountStatus: AccountStatusEnum.values.firstWhere(
        (e) => e.toString().split('.').last == json['accountStatus'],
        orElse: () =>
            throw Exception('Unknown status: ${json['accountStatus']}'),
      ),
      inactiveUser: json['inactiveUser'] ?? false,
      newUser: json['newUser'] ?? false,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        // If standard ISO8601 parsing fails, try custom format
        try {
          // Assuming format is "yyyy-MM-dd HH:mm:ss"
          List<String> parts = value.split(' ');
          String datePart = parts[0];
          String timePart = parts.length > 1 ? parts[1] : '00:00:00';
          return DateTime.parse('${datePart}T$timePart');
        } catch (e) {
          print('Error parsing date: $value');
          return null;
        }
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'activatedAt': activatedAt?.toIso8601String(),
      'roles': roles.map((role) => role.toJson()).toList(),
      'accountStatus': accountStatus.toString().split('.').last,
      'inactiveUser': inactiveUser,
      'newUser': newUser,
    };
  }
}
