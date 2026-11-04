import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/cubit/search_state.dart';
import '../../domain/entities/saved_route.dart';
import '../../../../core/themes/theme_data.dart';

/// Horizontally-scrollable chips showing favourite routes.
///
/// Design:
///   • Section title "Favourite routes" + left-aligned
///   • Chips: rounded pill, light gold-tinted background, gold border
///   • Each chip: originCode  →  destinationCode
///   • First chip is auto-highlighted (darker background)
///   • UI only — no tap callbacks wired to business logic
class FavoriteRoutesWidget extends StatefulWidget {
  final List<SavedRoute> routes;
  final SearchState state;

  const FavoriteRoutesWidget({
    super.key,
    required this.routes,
    required this.state,
  });

  @override
  State<FavoriteRoutesWidget> createState() => _FavoriteRoutesWidgetState();
}

class _FavoriteRoutesWidgetState extends State<FavoriteRoutesWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.routes.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ───────────────────────────────────────────────
        Text(
          'search.saved_routes'.tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : kColorPrimaryAction,
          ),
        ),
        const SizedBox(height: 14),

        // ── Horizontal chip list ─────────────────────────────────────────
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: widget.routes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final route = widget.routes[index];
              final isSelected = index == _selectedIndex;
              return _RouteChip(
                route: route,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () {
                  setState(() => _selectedIndex = index);
                
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Single chip ───────────────────────────────────────────────────────────────

class _RouteChip extends StatelessWidget {
  final SavedRoute route;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _RouteChip({
    required this.route,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Colours
    final Color bgSelected = kColorPrimaryAction;
    final Color bgUnselected = isDark
        ? kColorAccentGold.withValues(alpha: 0.10)
        : kColorAccentGold.withValues(alpha: 0.07);
    final Color borderSelected = kColorPrimaryAction;
    final Color borderUnselected = isDark
        ? kColorAccentGold.withValues(alpha: 0.50)
        : kColorAccentGold;
    final Color textSelected = Colors.white;
    final Color textUnselected = isDark ? Colors.white : kColorPrimaryAction;
    final Color arrowSelected = Colors.white.withValues(alpha: 0.70);
    final Color arrowUnselected = kColorAccentGold;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration: BoxDecoration(
          color: isSelected ? bgSelected : bgUnselected,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? borderSelected : borderUnselected,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: kColorPrimaryAction.withValues(alpha: 0.20),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              route.originCode,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textSelected,
                letterSpacing: 0.2,
              ).copyWith(color: isSelected ? textSelected : textUnselected),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.arrow_forward_rounded,
              size: 14,
              color: isSelected ? arrowSelected : arrowUnselected,
            ),
            const SizedBox(width: 6),
            Text(
              route.destinationCode,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ).copyWith(color: isSelected ? textSelected : textUnselected),
            ),
          ],
        ),
      ),
    );
  }
}
