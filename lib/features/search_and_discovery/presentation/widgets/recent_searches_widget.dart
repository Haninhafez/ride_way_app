import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/cubit/search_state.dart';
import '../../domain/entities/recent_search.dart';
import '../../../../core/themes/theme_data.dart';

/// Recent searches list – matches the reference screenshot.
///
/// Layout:
///   • Section header ("Recent searches") + "Clear" button opposite
///   • All items inside ONE white rounded card
///   • Each row: circular history icon | 2-line text | trailing chevron
///   • Thin dividers between rows (not below the last)
///   • UI only – onClear / onSelect are no-ops passed from the screen
class RecentSearchesWidget extends StatelessWidget {
  final List<RecentSearch> recentSearches;
  final VoidCallback onClear;
  final ValueChanged<RecentSearch> onSelect;
  
  final SearchState state;

  const RecentSearchesWidget({
    super.key,
    required this.recentSearches,
    required this.onClear,
    required this.onSelect, required this.state
  });

  @override
  Widget build(BuildContext context) {
    if (recentSearches.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ───────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'search.recent_searches'.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : kColorPrimaryAction,
              ),
            ),
            GestureDetector(
              onTap: onClear,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4, vertical: 4),
                child: Text(
                  'search.clear'.tr(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kColorAccentGold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Card container ───────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF2C2C2E)
                  : const Color(0xFFE5E5EA),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.04),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                for (int i = 0; i < recentSearches.length; i++) ...[
                  _SearchRow(
                    item: recentSearches[i],
                    isDark: isDark,
                    onTap: () => onSelect(recentSearches[i]),
                  ),
                  if (i < recentSearches.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 64,   // aligns under the text, not the icon
                      endIndent: 16,
                      color: isDark
                          ? const Color(0xFF2C2C2E)
                          : const Color(0xFFEFEFF4),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Single row ────────────────────────────────────────────────────────────────

class _SearchRow extends StatelessWidget {
  final RecentSearch item;
  final bool isDark;
  final VoidCallback onTap;

  const _SearchRow({
    required this.item,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = Directionality.of(context) == ui.TextDirection.rtl;

    final dateStr =
        DateFormat('EEE, d MMM').format(item.departureDate);
    final passengerLabel =
        '${item.passengerCount} ${'booking.passengers'.tr()}';

    // Route label: always LTR arrow regardless of locale
    final routeLabel = '${item.originName}  →  ${item.destinationName}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // ── Circular history icon ──────────────────────────────────
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? const Color(0xFF2C2C2E)
                      : kColorBackground,
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF3A3A3C)
                        : const Color(0xFFE5E5EA),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  size: 20,
                  color: kColorSubtitle,
                ),
              ),
              const SizedBox(width: 14),

              // ── Text column ────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Route — force LTR so arrow always points right
                    Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: Text(
                        routeLabel,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : kColorPrimaryAction,
                          height: 1.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Date · passengers
                    Text(
                      '$dateStr  ·  $passengerLabel',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: kColorSubtitle,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // ── Trailing chevron ───────────────────────────────────────
              Icon(
                isAr
                    ? Icons.arrow_back_ios_rounded
                    : Icons.arrow_forward_ios_rounded,
                size: 14,
                color: kColorSubtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
