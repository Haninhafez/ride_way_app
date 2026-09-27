import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ride_way_app/core/widgets/button_changing_language.dart';
import 'package:ride_way_app/core/widgets/notfication_button.dart';
import '../../../../core/themes/theme_data.dart';

class HeaderRow extends StatelessWidget {
  final String userName;
  final int unreadCount;
  final VoidCallback? onNotificationTap;

  const HeaderRow({
    super.key,
    required this.userName,
    this.unreadCount = 3,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // User Avatar Badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: KColorDarkGrey,
                border: Border.all(color: KColorDarkGold, width: 2),
              ),
              child: Center(
                child: Text(
                  userName.substring(0, 1),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kColorAccentGold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'search.greeting'.tr(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: kColorSubtitle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : kColorPrimaryAction,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Notification Bell Icon with Badge Counter
        ButtonChangingLanguage(),
      ],
    );
  }
}
