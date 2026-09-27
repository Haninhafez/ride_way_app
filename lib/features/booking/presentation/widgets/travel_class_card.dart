import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/travel_class.dart';
import '../../../../core/themes/theme_data.dart';

class TravelClassCard extends StatelessWidget {
  final TravelClass travelClass;
  final bool isSelected;
  final VoidCallback onTap;

  const TravelClassCard({
    super.key,
    required this.travelClass,
    required this.isSelected,
    required this.onTap,
  });

  Color _getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return isSelected ? const Color(0xFF2C2C2E) : const Color(0xFF1C1C1E);
    }
    // Warm/Class Tints: #FBEFE3 for Business, #EFF2E6 for Economy/First
    if (travelClass.id == 'business') {
      return const Color(0xFFFBEFE3);
    }
    return const Color(0xFFEFF2E6);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = _getBackgroundColor(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? kColorPrimaryAction
                : (isDark ? const Color(0xFF3A3A3C) : Colors.transparent),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? kColorPrimaryAction : Colors.white,
                        border: Border.all(
                          color: isSelected ? kColorPrimaryAction : kColorSubtitle,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      travelClass.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : kColorPrimaryAction,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'SAR ${travelClass.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : kColorPrimaryAction,
                      ),
                    ),
                    Text(
                      'booking.per_passenger'.tr(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: kColorSubtitle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.event_seat, size: 14, color: kColorAccentGold),
                  const SizedBox(width: 6),
                  Text(
                    '${travelClass.availableSeats} ${'booking.seats_left'.tr()}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kColorPrimaryAction,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            ...travelClass.perks.map(
              (perk) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: kColorSuccess,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        perk,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white70 : const Color(0xFF3A3A3C),
                          fontWeight: FontWeight.w500,
                        ),
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
