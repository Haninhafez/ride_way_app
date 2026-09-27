import 'package:flutter/material.dart';
import '../../domain/entities/trip_notification.dart';
import '../../../../core/themes/theme_data.dart';

class NotificationItemCard extends StatelessWidget {
  final TripNotification notification;
  final VoidCallback onTap;

  const NotificationItemCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  IconData _getIcon() {
    switch (notification.type) {
      case NotificationType.delay:
        return Icons.warning_amber_rounded;
      case NotificationType.reminder:
        return Icons.access_time_filled;
      case NotificationType.confirmation:
        return Icons.confirmation_number;
      case NotificationType.payment:
        return Icons.credit_card;
      case NotificationType.refund:
        return Icons.replay_outlined;
    }
  }

  Color _getTileBg() {
    switch (notification.type) {
      case NotificationType.delay:
        return const Color(0xFFFDF2F2); // Light Red
      case NotificationType.reminder:
        return const Color(0xFFFBEFE3); // Warm Amber
      case NotificationType.confirmation:
        return const Color(0xFFEFF2E6); // Sage
      case NotificationType.payment:
      case NotificationType.refund:
        return const Color(0xFFF2F2F7); // Neutral
    }
  }

  Color _getIconColor() {
    switch (notification.type) {
      case NotificationType.delay:
        return const Color(0xFFD93838);
      case NotificationType.reminder:
        return kColorAccentGold;
      case NotificationType.confirmation:
        return kColorSuccess;
      case NotificationType.payment:
      case NotificationType.refund:
        return kColorPrimaryAction;
    }
  }

  String _getTimestampLabel() {
    final diff = DateTime.now().difference(notification.timestamp);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else {
      return '${diff.inDays} days ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: notification.isUnread
                ? kColorAccentGold.withOpacity(0.5)
                : (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA)),
            width: notification.isUnread ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Tile (Kind-tinted)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2E) : _getTileBg(),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _getIcon(),
                size: 24,
                color: _getIconColor(),
              ),
            ),
            const SizedBox(width: 14),

            // Content Block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : kColorPrimaryAction,
                          ),
                        ),
                      ),
                      if (notification.isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: kColorAccentGold,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : const Color(0xFF3A3A3C),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getTimestampLabel(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: kColorSubtitle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
