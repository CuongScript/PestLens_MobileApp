import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pest_lens_app/utils/config.dart';
import 'package:pest_lens_app/utils/user_preferences.dart';

class AdminService {
  static const String baseUrl = '${Config.apiUrl}/api/users';

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final user = await UserPreferences.getUser();

    if (user == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': '${user.tokenType} ${user.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
