import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/notifications_cubit.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/notifications_state.dart';
import 'package:ride_way_app/features/trips/presentation/widgets/notification_item_card.dart';

import '../../../core/themes/theme_data.dart';

class NotficationScreen extends StatefulWidget {
  const NotficationScreen({super.key});

  @override
  State<NotficationScreen> createState() => _NotficationScreenState();
}

class _NotficationScreenState extends State<NotficationScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final cubit = context.read<NotificationsCubit>();

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F131A) : kColorBackground,
          appBar: AppBar(
            backgroundColor: isDark
                ? const Color(0xFF0F131A)
                : kColorBackground,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'notification.title'.tr(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : kColorPrimaryAction,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${cubit.unreadNoticationCount} ${'notification.unread'.tr()}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: isDark ? Colors.white70 : kColorPrimaryAction,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: cubit.unreadNoticationCount == 0
                    ? null
                    : () => cubit.markAllAsRead(),
                child: Text(
                  'notification.mark_all_as_read'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? kColorAccentGold : KColorDarkGold,
                  ),
                ),
              ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(NotificationsState state) {
    switch (state.status) {
      case NotificationsStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case NotificationsStatus.error:
        return Center(
          child: Text(
            state.errorMessage ?? 'notification.errors.load_failed'.tr(),
          ),
        );

      case NotificationsStatus.success:
        final notifications = [...state.allNotifications];

        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 12),
                Text(
                  'notification.empty_title'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('notification.empty_message'.tr()),
              ],
            ),
          );
        }

        notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        final now = DateTime.now();

        final todayNotifications = notifications.where((n) {
          return n.timestamp.year == now.year &&
              n.timestamp.month == now.month &&
              n.timestamp.day == now.day;
        }).toList();

        final earlierNotifications = notifications.where((n) {
          return n.timestamp.year != now.year ||
              n.timestamp.month != now.month ||
              n.timestamp.day != now.day;
        }).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            if (todayNotifications.isNotEmpty) ...[
              _buildSectionTitle('notification.today'.tr()),
              ...todayNotifications.map(_buildNotificationItem),
            ],

            if (earlierNotifications.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionTitle('notification.earlier'.tr()),
              ...earlierNotifications.map(_buildNotificationItem),
            ],
          ],
        );

      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white70
              : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(notification) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: NotificationItemCard(
        notification: notification,
        onTap: () {
          context.read<NotificationsCubit>().markAsRead(notification.id);
        },
      ),
    );
  }
}
