enum Role {
  ROLE_ADMIN,
  ROLE_USER,
}

extension RoleExtension on Role {
  static Role fromString(String role) {
    switch (role) {
      case 'ROLE_ADMIN':
        return Role.ROLE_ADMIN;
      case 'ROLE_USER':
        return Role.ROLE_USER;
      default:
        throw Exception('Unknown role: $role');
    }
  }

  static Role fromJson(Map<String, dynamic> json) {
    final roleName = json['name'] as String;
    return fromString(roleName);
  }

  String toJson() {
    return toString().split('.').last;
  }
}
