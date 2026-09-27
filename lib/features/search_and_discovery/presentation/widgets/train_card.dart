import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/train_search_result.dart';
import '../../../../core/themes/theme_data.dart';

class TrainCard extends StatelessWidget {
  final TrainSearchResult train;
  final VoidCallback onViewDetails;

  const TrainCard({
    super.key,
    required this.train,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLowSeat = train.isLowSeat;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Code Badge + Train Name + Starting Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: kColorAccentGold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kColorAccentGold, width: 1),
                    ),
                    child: Text(
                      train.trainCode,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: kColorAccentGold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    train.trainName,
                    style: TextStyle(
                      fontSize: 14,
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
                    'from SAR ${train.startingPrice.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kColorPrimaryAction,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'per passenger',
                    style: TextStyle(fontSize: 11, color: kColorSubtitle),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Departure & Arrival Block
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    train.departureTime,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kColorPrimaryAction,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Enforce LTR for station codes
                  Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Text(
                      train.originCode,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: kColorSubtitle,
                      ),
                    ),
                  ),
                ],
              ),

              // Route duration indicator line
              Column(
                children: [
                  Text(
                    train.duration,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kColorSubtitle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 3,
                        backgroundColor: kColorAccentGold,
                      ),
                      Container(width: 40, height: 2, color: kColorAccentGold),
                      const Icon(
                        Icons.train_outlined,
                        size: 16,
                        color: kColorAccentGold,
                      ),
                      Container(width: 40, height: 2, color: kColorAccentGold),
                      const CircleAvatar(
                        radius: 3,
                        backgroundColor: kColorAccentGold,
                      ),
                    ],
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    train.arrivalTime,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kColorPrimaryAction,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Text(
                      train.destinationCode,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: kColorSubtitle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Seat Availability & Action Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Seat Availability Indicator (Warning red/amber vs neutral)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isLowSeat
                      ? const ui.Color.fromARGB(170, 97, 26, 26)
                      : kColorSubtitle.withAlpha(20),

                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isLowSeat
                          ? Icons.warning_amber_rounded
                          : Icons.event_seat,
                      size: 18,
                      color: isLowSeat
                          ? const Color(0xFFD93838)
                          : kColorSubtitle,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isLowSeat
                          ? 'train_list.low_seats'.tr(
                              args: ['${train.availableSeatsCount}'],
                            )
                          : 'train_list.seats_available'.tr(
                              args: ['${train.availableSeatsCount}'],
                            ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isLowSeat
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isLowSeat
                            ? const Color(0xFFD93838)
                            : kColorSubtitle,
                      ),
                    ),
                  ],
                ),
              ),

              // Action Pill Button: "View details"
              ElevatedButton(
                onPressed: onViewDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff2A2F22),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'train_list.view_details'.tr(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
