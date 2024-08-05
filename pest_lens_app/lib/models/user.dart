import 'package:pest_lens_app/models/role_enum.dart';

class User {
  String id;
  String username;
  List<Role> roles;
  String accessToken;
  String tokenType;

  User({
    required this.id,
    required this.username,
    required this.roles,
    required this.accessToken,
    required this.tokenType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      roles: (json['roles'] as List)
          .map((role) => RoleExtension.fromString(role))
          .toList(),
      accessToken: json['accessToken'],
      tokenType: json['tokenType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'roles': roles.map((role) => role.toJson()).toList(),
      'accessToken': accessToken,
      'tokenType': tokenType,
    };
  }
}
