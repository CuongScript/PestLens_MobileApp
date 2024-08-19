import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/models/notification_model.dart';
import 'package:pest_lens_app/services/notification_service.dart';

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
  NotificationNotifier() : super(const AsyncValue.loading()) {
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    // TODO: Implement actual loading logic, possibly from local storage or an API

    state = AsyncValue.data([
      Notification(
          id: '1',
          title: 'Number of Rice Asian Gall Midge reached 100.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 1))),
      Notification(
          id: '2',
          title: 'Camera activated.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 59))),
      Notification(
          id: '3',
          title: 'Number of Rice Asian Gall Midge reached 50.',
          timestamp: DateTime.now().subtract(const Duration(hours: 6))),
      Notification(
          id: '4',
          title: 'Camera disabled.',
          timestamp: DateTime.now().subtract(const Duration(hours: 23))),
      Notification(
          id: '5',
          title: 'Number of Rice Asian Gall Midge reached 100.',
          timestamp: DateTime.now().subtract(const Duration(days: 3))),
    ]);
  }

  void addNotification(Notification notification) {
    state.whenData((notifications) {
      state = AsyncValue.data([notification, ...notifications]);
    });
  }
}
