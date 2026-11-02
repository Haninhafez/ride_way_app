import 'package:easy_localization/easy_localization.dart';
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
        return Icons.access_time_rounded;
      case NotificationType.confirmation:
        return Icons.confirmation_number_outlined;
      case NotificationType.payment:
        return Icons.account_balance_wallet_outlined;
      case NotificationType.refund:
        return Icons.replay_rounded;
    }
  }

  Color _getTileBg() {
    switch (notification.type) {
      case NotificationType.delay:
        return const Color(0xFFFCE8E6);
      case NotificationType.reminder:
        return const Color(0xFFFFF2D9);
      case NotificationType.confirmation:
        return const Color(0xFFEEF2E5);
      case NotificationType.payment:
      case NotificationType.refund:
        return const Color(0xFFFBEBDD);
    }
  }

  Color _getIconColor() {
    switch (notification.type) {
      case NotificationType.delay:
        return const Color(0xFFD93838);
      case NotificationType.reminder:
        return const Color(0xFFB78B36);
      case NotificationType.confirmation:
        return const Color(0xFF77845D);
      case NotificationType.payment:
      case NotificationType.refund:
        return const Color(0xFFD18B55);
    }
  }

  String _getTimestampLabel(BuildContext context) {
    final now = DateTime.now();
    final timestamp = notification.timestamp;
    final difference = now.difference(timestamp);

    if (difference.isNegative) {
      return DateFormat('h:mm a').format(timestamp);
    }

    if (difference.inMinutes < 1) {
      return 'notification.time.just_now'.tr();
    }

    if (difference.inHours < 1) {
      return 'notification.time.minutes_ago'.tr(
        namedArgs: {'minutes': '${difference.inMinutes}'},
      );
    }

    if (difference.inHours < 24 &&
        now.day == timestamp.day &&
        now.month == timestamp.month &&
        now.year == timestamp.year) {
      return DateFormat('h:mm a').format(timestamp);
    }

    if (difference.inDays < 2) {
      return 'notification.time.yesterday'.tr();
    }

    return DateFormat('MMM d').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C222B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF2C3440) : const Color(0xFFECECEC),
            ),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.035),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark
                      ? _getTileBg().withValues(alpha: 0.15)
                      : _getTileBg(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getIcon(), size: 20, color: _getIconColor()),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: notification.isUnread
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF303238),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getTimestampLabel(context),
                          style: TextStyle(
                            fontSize: 9,
                            color: isDark
                                ? Colors.white54
                                : const Color(0xFF888888),
                          ),
                        ),
                        if (notification.isUnread) ...[
                          const SizedBox(width: 5),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: kColorAccentGold,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      notification.message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF696B70),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
