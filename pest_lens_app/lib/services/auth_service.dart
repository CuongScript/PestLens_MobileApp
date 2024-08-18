import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pest_lens_app/models/user.dart';
import 'package:pest_lens_app/utils/config.dart';
import 'package:pest_lens_app/utils/user_preferences.dart';

class AuthService {
  Future<User?> signUserIn(String username, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('${Config.apiUrl}/login'));
    request.body = json.encode({"username": username, "password": password});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      User user = User.fromJson(jsonResponse);

      // Save user information
      await UserPreferences.saveUser(user);

      // Register device ID
      await registerDeviceId(user.username, user.tokenType, user.accessToken);

      return user;
    } else {
      return null;
    }
  }

  Future<bool> registerDeviceId(
      String username, String tokenType, String accessToken) async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? deviceId = await firebaseMessaging.getToken();
    if (deviceId != null) {
      // Encode the username and deviceId
      String encodedUsername = Uri.encodeQueryComponent(username);
      String encodedDeviceId = Uri.encodeQueryComponent(deviceId);
      print('User device id: $encodedDeviceId');
      print('User username: $encodedUsername');
      var url = Uri.parse('${Config.apiUrl}/api/users/register-device-id');

      try {
        var response = await http.post(
          url,
          headers: {
            'Authorization': '$tokenType $accessToken',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'username': encodedUsername,
            'deviceId': encodedDeviceId,
          },
        );

        if (response.statusCode == 200) {
          print('Success to register device ID: ${response.body}');
          return true;
        } else {
          print('Failed to register device ID: ${response.body}');
          return false;
        }
      } catch (e) {
        print('Error registering device ID: $e');
        return false;
      }
    }
    return false;
  }
}
