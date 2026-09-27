import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/recent_search.dart';
import '../../../../core/themes/theme_data.dart';

class RecentSearchesWidget extends StatelessWidget {
  final List<RecentSearch> recentSearches;
  final VoidCallback onClear;
  final ValueChanged<RecentSearch> onSelect;

  const RecentSearchesWidget({
    super.key,
    required this.recentSearches,
    required this.onClear,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (recentSearches.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'search.recent_searches'.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : kColorPrimaryAction,
              ),
            ),
            TextButton(
              onPressed: onClear,
              child: Text(
                'search.clear'.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kColorAccentGold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...recentSearches.map((item) {
          final dateStr = DateFormat('EEE, d MMM').format(item.departureDate);

          return GestureDetector(
            onTap: () => onSelect(item),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.history, size: 20, color: kColorSubtitle),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${item.originCode} ➔ ${item.destinationCode} · $dateStr · ${item.passengerCount} ${'booking.passengers'.tr()}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : kColorPrimaryAction,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: kColorSubtitle),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
