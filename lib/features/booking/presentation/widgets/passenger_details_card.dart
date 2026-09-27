import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/passenger.dart';
import '../../../../core/themes/theme_data.dart';

class PassengerDetailsCard extends StatelessWidget {
  final Passenger passenger;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final Function(String name, String id) onChanged;

  const PassengerDetailsCard({
    super.key,
    required this.passenger,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final seatLabel = passenger.assignedSeat?.seatNumber ?? '12A';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
        ),
      ),
      child: Column(
        children: [
          // Header / Toggle
          Semantics(
            label: 'Passenger ${passenger.index} details, ${isExpanded ? "expanded" : "collapsed"}',
            button: true,
            child: InkWell(
              onTap: onToggleExpand,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: kColorPrimaryAction,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${passenger.index}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'booking.passenger_details.passenger_card'.tr(args: ['${passenger.index}']),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : kColorPrimaryAction,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            passenger.fullName.isNotEmpty
                                ? passenger.fullName
                                : 'Tap to enter passenger details',
                            style: const TextStyle(
                              fontSize: 13,
                              color: kColorSubtitle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Seat $seatLabel',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : kColorPrimaryAction,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: kColorSubtitle,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Collapsible Form
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: passenger.fullName,
                    decoration: InputDecoration(
                      labelText: 'booking.passenger_details.full_name'.tr(),
                      hintText: 'booking.passenger_details.full_name_hint'.tr(),
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF2C2C2E) : kColorFieldFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: kColorBorder),
                      ),
                    ),
                    onChanged: (val) => onChanged(val, passenger.nationalIdOrPassport),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: passenger.nationalIdOrPassport,
                    decoration: InputDecoration(
                      labelText: 'booking.passenger_details.national_id'.tr(),
                      hintText: 'booking.passenger_details.national_id_hint'.tr(),
                      prefixIcon: const Icon(Icons.badge_outlined),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF2C2C2E) : kColorFieldFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: kColorBorder),
                      ),
                    ),
                    onChanged: (val) => onChanged(passenger.fullName, val),
                  ),
                ],
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
