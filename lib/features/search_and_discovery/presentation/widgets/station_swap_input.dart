import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/station.dart';
import '../../../../core/themes/theme_data.dart';

class StationSwapInput extends StatelessWidget {
  final Station origin;
  final Station destination;
  final VoidCallback onSwap;
  final ValueChanged<Station>? onOriginTap;
  final ValueChanged<Station>? onDestinationTap;

  const StationSwapInput({
    super.key,
    required this.origin,
    required this.destination,
    required this.onSwap,
    this.onOriginTap,
    this.onDestinationTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5EA),
        ),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Column(
            children: [
              // From Field
              _buildStationRow(
                context: context,
                label: 'search.from'.tr(),
                station: origin,
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              // To Field
              _buildStationRow(
                context: context,
                label: 'search.to'.tr(),
                station: destination,
                isDark: isDark,
              ),
            ],
          ),

          // Swap Directional Button (⇅)
          Semantics(
            label: 'search.swap_stations'.tr(),
            button: true,
            child: InkWell(
              onTap: onSwap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: kColorPrimaryAction,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '⇅',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationRow({
    required BuildContext context,
    required String label,
    required Station station,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(
          label == 'search.from'.tr()
              ? Icons.location_on_outlined
              : Icons.place_outlined,
          color: kColorAccentGold,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: kColorSubtitle,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                station.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kColorPrimaryAction,
                ),
              ),
            ],
          ),
        ),
        // Enforce strictly LTR format for station codes (e.g., "DMM", "JED") across both English & Arabic locales
        Directionality(
          textDirection: ui.TextDirection.ltr,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: kColorAccentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              station.stationCode,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: kColorAccentGold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 44), // Space for floating swap button
      ],
    );
  }
}
