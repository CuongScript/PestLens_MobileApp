import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pest_lens_app/models/role_enum.dart';
import 'package:pest_lens_app/models/user.dart';
import 'package:pest_lens_app/utils/config.dart';
import 'package:pest_lens_app/preferences/user_preferences.dart';
import 'package:pest_lens_app/services/s3_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pest_lens_app/models/user_full_info_model.dart';

class AuthService {
  final S3Service _s3Service = S3Service();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  Future<User?> signInWithGoogle() async {
    try {
      _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Use the idToken to authenticate with your backend

      final response = await http.get(
        Uri.parse(
            '${Config.apiUrl}/api/users/search?username=${Uri.encodeComponent(googleUser.email)}'),
        headers: {
          'Authorization': 'Bearer ${googleAuth.idToken}',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);

        User user = User(
            id: userData['id'],
            username: userData['username'],
            roles: [Role.ROLE_USER],
            accessToken: googleAuth.idToken.toString(),
            tokenType: 'Bearer');
        await UserPreferences.saveUser(user);

        // Register device ID
        await registerDeviceId(user.username, user.tokenType, user.accessToken);

        return user;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

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
        } else {
          return false;
        }
      } catch (e) {
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

  Future<bool> fetchUserFullInformation() async {
    try {
      // Retrieve user information from preferences
      User? user = await UserPreferences.getUser();

      if (user == null) {
        return false;
      }

      var headers = {'Authorization': '${user.tokenType} ${user.accessToken}'};

      var request = http.Request(
          'GET',
          Uri.parse(
              '${Config.apiUrl}/api/users/search?username=${Uri.encodeComponent(user.username)}'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> userData = json.decode(responseBody);

        UserFullInfoModel userFullInfo = UserFullInfoModel.fromJson(userData);

        // Save the full user information to preferences
        await UserPreferences.saveCurrentUserProfileInformation(userFullInfo);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
