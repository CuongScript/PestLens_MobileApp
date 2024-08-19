import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/models/notification_model.dart';
import 'package:pest_lens_app/preferences/user_preferences.dart';
import 'package:pest_lens_app/services/notification_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pest_lens_app/models/user.dart';
import 'package:pest_lens_app/utils/config.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, AsyncValue<List<Notification>>>(
        (ref) {
  return NotificationNotifier();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final notifier = ref.watch(notificationProvider.notifier);
  return NotificationService(notifier);
});

class NotificationNotifier
    extends StateNotifier<AsyncValue<List<Notification>>> {
  NotificationNotifier() : super(const AsyncValue.loading());

  Future<void> loadNotifications() async {
    try {
      User? user = await UserPreferences.getUser();
      if (user == null) {
        throw Exception('User not found');
      }

      var headers = {'Authorization': '${user.tokenType} ${user.accessToken}'};

      var request = http.Request(
          'GET',
          Uri.parse(
              '${Config.apiUrl}/api/users/get-push-notification?username=${user.username}'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        List<dynamic> jsonList = json.decode(responseBody);

        List<Notification> notifications = jsonList
            .map((json) => Notification(
                  id: json['id'].toString(),
                  title: json['message'],
                  timestamp: DateTime.parse(json['sentAt']),
                ))
            .toList();

        state = AsyncValue.data(notifications);
      } else {
        throw Exception(
            'Failed to load notifications: ${response.reasonPhrase}');
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void addNotification(Notification notification) {
    state.whenData((notifications) {
      state = AsyncValue.data([notification, ...notifications]);
    });
  }
}
