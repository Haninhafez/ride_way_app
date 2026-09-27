import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/route_stop.dart';
import '../../../../core/themes/theme_data.dart';

class RouteTimeline extends StatelessWidget {
  final List<RouteStop> stops;

  const RouteTimeline({
    super.key,
    required this.stops,
  });

  String _getTranslatedStationName(String name, String code) {
    if (code == 'DMM') return 'booking.stops.dammam'.tr();
    if (code == 'HFR') return 'booking.stops.hafar'.tr();
    if (code == 'RUH') return 'booking.stops.riyadh'.tr();
    if (code == 'KAEC') return 'booking.stops.kaec'.tr();
    if (code == 'JED') return 'booking.stops.jeddah'.tr();
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.alt_route, size: 20, color: kColorAccentGold),
              const SizedBox(width: 8),
              Text(
                'booking.stops_and_route'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kColorPrimaryAction,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stops.length,
            itemBuilder: (context, index) {
              final stop = stops[index];
              final isFirst = index == 0;
              final isLast = index == stops.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline Rail (Automatically aligns Left in LTR & Right in RTL)
                    Column(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isFirst || isLast
                                ? kColorAccentGold
                                : (stop.isPassed ? kColorPrimaryAction : Colors.transparent),
                            border: Border.all(
                              color: isFirst || isLast
                                  ? kColorAccentGold
                                  : kColorPrimaryAction,
                              width: 2,
                            ),
                          ),
                          child: (isFirst || isLast)
                              ? const Center(
                                  child: CircleAvatar(
                                    radius: 3,
                                    backgroundColor: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: stop.isPassed
                                  ? kColorPrimaryAction
                                  : kColorBorder,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Stop Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getTranslatedStationName(
                                      stop.stationName, stop.stationCode),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: (isFirst || isLast)
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isDark
                                        ? Colors.white
                                        : kColorPrimaryAction,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  stop.stationCode,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: kColorSubtitle,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF2C2C2E)
                                    : const Color(0xFFF2F2F7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                stop.departureTime,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : kColorPrimaryAction,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
