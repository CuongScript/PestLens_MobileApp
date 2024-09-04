import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/notification_card.dart';
import 'package:pest_lens_app/provider/notification_service_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  void initState() {
    super.initState();
    // Subscribe to FCM topics and load notifications
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationService = ref.read(notificationServiceProvider);
      notificationService.subscribeToTopic('USER_CREATED');
      notificationService.subscribeToTopic('PEST_COUNT');

      // Load notifications when the page mounts
      ref.read(notificationProvider.notifier).loadNotifications();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: Text(AppLocalizations.of(context)!.notification,
            style: CustomTextStyles.pageTitle),
        elevation: 0,
      ),
      body: notifications.when(
        data: (notificationList) {
          if (notificationList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.noNotify,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.caughtUpNotify,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final todayNotifications =
              notificationList.where((n) => n.isToday()).toList();
          final olderNotifications =
              notificationList.where((n) => !n.isToday()).toList();

          return ListView(
            children: [
              if (todayNotifications.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    AppLocalizations.of(context)!.today,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...todayNotifications.map((notification) => NotificationCard(
                      title: notification.title,
                      time: notification.getTimeAgo(),
                      icon: notification.getIcon(),
                    )),
              ],
              if (olderNotifications.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    AppLocalizations.of(context)!.last7Day,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
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
        error: (error, stack) => Center(
            child: Text('${AppLocalizations.of(context)!.error}: $error')),
      ),
    );
  }
}
