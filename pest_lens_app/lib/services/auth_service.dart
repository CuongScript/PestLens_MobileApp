import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pest_lens_app/models/user.dart';
import 'package:pest_lens_app/utils/config.dart';
import 'package:pest_lens_app/preferences/user_preferences.dart';
import 'package:pest_lens_app/services/s3_service.dart';

class AuthService {
  final S3Service _s3Service = S3Service();

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
      print('User device id: $deviceId');
      print('User username: $username');

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': '$tokenType $accessToken'
      };

      var request = http.Request(
          'POST', Uri.parse('${Config.apiUrl}/api/users/register-device-id'));

      request.body = json.encode({"username": username, "deviceId": deviceId});

      request.headers.addAll(headers);

      try {
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          print(
              'Success to register device ID: ${await response.stream.bytesToString()}');
          return true;
        } else {
          print('Failed to register device ID: ${response.reasonPhrase}');
          return false;
        }
      } catch (e) {
        print('Error registering device ID: $e');
        return false;
      }
    }
    return false;
  }

  Future<Map<String, dynamic>> signUserUp(
      Map<String, dynamic> userData, File? profileImage) async {
    String? profileImageKey;

    if (profileImage != null) {
      try {
        profileImageKey = await _s3Service.uploadProfileImage(profileImage);
      } catch (e) {
        print('Failed to upload profile image: $e');
        // Return with error, but don't stop the signup process
        return {
          'success': false,
          'message':
              'Failed to upload profile image, but continuing with signup.',
          'imageUploadFailed': true
        };
      }
    }

    if (profileImageKey != null) {
      userData['avatarUrl'] = profileImageKey;
    }

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('${Config.apiUrl}/signup'));
    request.body = json.encode(userData);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Signup successful'};
      } else {
        return {
          'success': false,
          'message': 'Signup failed: ${response.reasonPhrase}',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error during signup: $e'};
    }
  }
}
