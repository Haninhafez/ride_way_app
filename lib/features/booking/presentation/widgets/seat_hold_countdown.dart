import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/theme_data.dart';

class SeatHoldCountdown extends StatelessWidget {
  final String formattedTime;

  const SeatHoldCountdown({
    super.key,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      liveRegion: true,
      label: 'booking.passenger_details.hold_banner'.tr(args: [formattedTime]),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2518) : const Color(0xFFFFF9ED),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: kColorAccentGold.withOpacity(0.4),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: kColorAccentGold,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.timer_outlined,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : kColorPrimaryAction,
                  ),
                  children: [
                    TextSpan(
                      text: '${'booking.passenger_details.hold_banner'.tr(args: [''])} ',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: formattedTime,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kColorAccentGold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
