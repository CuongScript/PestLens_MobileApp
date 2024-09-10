import 'package:pest_lens_app/models/account_status_enum.dart';
import 'package:pest_lens_app/models/role_enum.dart';
import 'package:pest_lens_app/models/user.dart';
import 'package:pest_lens_app/models/user_full_info_model.dart';
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

  static Future<void> saveCurrentUserProfileInformation(
      UserFullInfoModel userInformations) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', userInformations.email);
    prefs.setString('firstName', userInformations.firstName);
    prefs.setString('lastName', userInformations.lastName);
    prefs.setString('phoneNumber', userInformations.phoneNumber ?? '');
    prefs.setString('avatarUrl', userInformations.avatarUrl ?? '');
    prefs.setString('createdAt', userInformations.createdAt.toString());
    prefs.setString('lastLogin', userInformations.lastLogin.toString());
    prefs.setString('activatedAt', userInformations.activatedAt.toString());
    prefs.setStringList(
        'roles', userInformations.roles.map((role) => role.toJson()).toList());
    prefs.setString(
        'accountStatus', userInformations.accountStatus.name.toString());
    prefs.setBool('inactiveUser', userInformations.inactiveUser);
    prefs.setBool('newUser', userInformations.newUser);
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

  static Future<UserFullInfoModel?> getCurrentUserProfileInformation() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? username = prefs.getString('username');
    String? firstName = prefs.getString('firstName');
    String? lastName = prefs.getString('lastName');
    String? phoneNumber = prefs.getString('phoneNumber');
    String? avatarUrl = prefs.getString('avatarUrl');
    String? createdAt = prefs.getString('createdAt');
    String? lastLogin = prefs.getString('lastLogin');
    String? activatedAt = prefs.getString('activatedAt');
    List<String>? roles = prefs.getStringList('roles');
    String? accountStatus = prefs.getString('accountStatus');
    bool? inactiveUser = prefs.getBool('inactiveUser');
    bool? newUser = prefs.getBool('newUser');

    if (email != null &&
        firstName != null &&
        username != null &&
        lastName != null &&
        createdAt != null &&
        roles != null &&
        accountStatus != null &&
        inactiveUser != null &&
        newUser != null) {
      return UserFullInfoModel(
        id: '',
        username: username,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        avatarUrl: avatarUrl,
        createdAt: DateTime.parse(createdAt),
        lastLogin: lastLogin != null && !lastLogin.contains('null')
            ? DateTime.parse(lastLogin)
            : null,
        activatedAt: activatedAt != null && !activatedAt.contains('null')
            ? DateTime.parse(activatedAt)
            : null,
        roles: roles.map((role) => RoleExtension.fromString(role)).toList(),
        accountStatus: AccountStatusEnum.values.firstWhere(
          (e) => e.toString().split('.').last == accountStatus,
          orElse: () => throw Exception('Unknown status: $accountStatus'),
        ),
        inactiveUser: inactiveUser,
        newUser: newUser,
      );
    }
    return null;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
