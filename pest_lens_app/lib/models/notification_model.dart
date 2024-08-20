import 'package:flutter/material.dart';

class Notification {
  final String id;
  final String title;
  final DateTime timestamp;

  Notification({
    required this.id,
    required this.title,
    required this.timestamp,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'].toString(),
      title: json['message'],
      timestamp: DateTime.parse(json['sentAt']),
    );
  }

  bool isToday() {
    final now = DateTime.now();
    return timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day;
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  IconData getIcon() {
    if (title.contains('Camera')) {
      return Icons.camera_alt;
    } else if (title.contains('Rice Asian Gall Midge')) {
      return Icons.bug_report;
    } else {
      return Icons.notifications;
    }
  }
}
