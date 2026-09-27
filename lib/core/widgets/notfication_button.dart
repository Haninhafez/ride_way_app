
import 'package:flutter/material.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';

class Notfication_button extends StatelessWidget {
  const Notfication_button({
    super.key,
    required this.unreadCount,
    required this.onNotificationTap,
    required this.isDark,
  });

  final int unreadCount;
  final VoidCallback? onNotificationTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Notifications, $unreadCount unread',
      button: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            onPressed: onNotificationTap,
            icon: Icon(
              Icons.notifications_outlined,
              size: 26,
              color: isDark ? Colors.white : kColorPrimaryAction,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFD93838), // Crimson warning badge
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  '$unreadCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
