import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers/notification/notification_provider.dart';
import '../../domain/entities/notification/notification_entity.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(watchNotificationsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications',
            style: TextStyle(color: Color(0xFF0652C5), fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.reply, color: Color(0xFF0652C5)),
          onPressed: context.pop,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final success = await ref.read(markAllNotificationAsReadProvider.future);
              if (success) {
                ref.invalidate(watchNotificationsProvider);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to mark all notifications as read')));
                }
              }
            },
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: notifications.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text("No Notifications Found"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = list[index];

              return _NotificationCard(notification: notification);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  final NotificationEntity notification;
  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (!notification.isRead) {
          final success = await ref.read(markNotificationAsReadProvider(notification.id).future);
          if (success) {
            ref.invalidate(watchNotificationsProvider);
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to mark notification as read')));
            }
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: notification.isRead ? null : Colors.blue.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timestamp
            Text(
              _formatNotificationDate(notification.receivedAt),
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8.0),

            // Title
            Text(
              notification.title ?? 'No Title',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4.0),

            // Description
            Text(
              notification.body ?? 'No Description',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
                height: 1.4, // Line height for better readability
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatNotificationDate(DateTime receivedAt) {
  final localDate = receivedAt.toLocal();
  DateTime now = DateTime.now();

  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime targetDate = DateTime(localDate.year, localDate.month, localDate.day);

  int differenceInDays = today.difference(targetDate).inDays;

  String timeString = DateFormat('HH.mm').format(localDate);

  // 4. Determine the timezone label
  // Note: localDate.timeZoneName usually returns standard abbreviations (like WIB, WITA),
  // but if it returns something like "GMT+7" on certain devices, you can hardcode "WIB"
  // if your app is specifically localized for that region.
  String timeZone = localDate.timeZoneName.toUpperCase();

  // 5. Determine the relative day string
  String dateString;
  if (differenceInDays == 0) {
    dateString = 'Today';
  } else if (differenceInDays == 1) {
    dateString = 'Yesterday';
  } else if (differenceInDays > 1 && differenceInDays < 7) {
    // Returns the short day name (e.g., "Mon", "Tue", "Thu")
    dateString = DateFormat('E').format(localDate);
  } else {
    // Fallback for dates older than a week (e.g., "12 Oct")
    dateString = DateFormat('dd MMM').format(localDate);
  }

  // 6. Combine everything into the final string
  return '$dateString - $timeString $timeZone';
}