import 'package:pest_lens_app/models/role_enum.dart';
import 'package:pest_lens_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', user.id);
    prefs.setString('username', user.username);
    prefs.setStringList(
        'roles', user.roles.map((role) => role.toJson()).toList());
    prefs.setString('accessToken', user.accessToken);
    prefs.setString('tokenType', user.tokenType);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    String? username = prefs.getString('username');
    List<String>? roles = prefs.getStringList('roles');
    String? accessToken = prefs.getString('accessToken');
    String? tokenType = prefs.getString('tokenType');

    if (id != null &&
        username != null &&
        roles != null &&
        accessToken != null &&
        tokenType != null) {
      return User(
        id: id,
        username: username,
        roles: roles.map((role) => RoleExtension.fromString(role)).toList(),
        accessToken: accessToken,
        tokenType: tokenType,
      );
    }
    return null;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
