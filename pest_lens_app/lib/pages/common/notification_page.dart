import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/notification_card.dart';
import 'package:pest_lens_app/provider/notification_service_provider.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  void initState() {
    super.initState();
    // Subscribe to FCM topics when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationService = ref.read(notificationServiceProvider);
      notificationService.subscribeToTopic('USER_CREATED');
      notificationService.subscribeToTopic('CAMERA_STATUS');
      notificationService.subscribeToTopic('PEST_COUNT');
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: const Text('Notifications', style: CustomTextStyles.pageTitle),
        elevation: 0,
      ),
      body: notifications.when(
        data: (notificationList) {
          final todayNotifications =
              notificationList.where((n) => n.isToday()).toList();
          final olderNotifications =
              notificationList.where((n) => !n.isToday()).toList();

          return ListView(
            children: [
              if (todayNotifications.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Today',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...todayNotifications.map((notification) => NotificationCard(
                      title: notification.title,
                      time: notification.getTimeAgo(),
                      icon: notification.getIcon(),
                    )),
              ],
              if (olderNotifications.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'Last 7 Days',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...olderNotifications.map((notification) => NotificationCard(
                      title: notification.title,
                      time: notification.getTimeAgo(),
                      icon: notification.getIcon(),
                    )),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
