import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AmenitiesList extends StatelessWidget {
  final List<String> amenities;

  const AmenitiesList({
    super.key,
    required this.amenities,
  });

  IconData _getIconForAmenity(String amenity) {
    final lower = amenity.toLowerCase();
    if (lower.contains('wi-fi') || lower.contains('wifi')) return Icons.wifi;
    if (lower.contains('dining') || lower.contains('food')) return Icons.restaurant;
    if (lower.contains('power') || lower.contains('outlet')) return Icons.power;
    if (lower.contains('quiet')) return Icons.volume_off_outlined;
    return Icons.star_outline;
  }

  String _getTranslatedAmenity(String amenity) {
    final lower = amenity.toLowerCase();
    if (lower.contains('wi-fi') || lower.contains('wifi')) return 'booking.amenities.wifi'.tr();
    if (lower.contains('dining')) return 'booking.amenities.dining'.tr();
    if (lower.contains('power')) return 'booking.amenities.power'.tr();
    if (lower.contains('quiet')) return 'booking.amenities.quiet'.tr();
    return amenity;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: amenities.map((amenity) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5EA),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIconForAmenity(amenity),
                  size: 16,
                  color: isDark ? const Color(0xFFD1A546) : const Color(0xFF181818),
                ),
                const SizedBox(width: 6),
                Text(
                  _getTranslatedAmenity(amenity),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF181818),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
