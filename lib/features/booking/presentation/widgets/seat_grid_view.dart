import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/passenger.dart';
import '../../domain/entities/seat.dart';
import '../../../../core/themes/theme_data.dart';

class SeatGridView extends StatelessWidget {
  final String selectedCoach;
  final List<Seat> seats;
  final List<Seat> selectedSeats;
  final List<Passenger> passengers;
  final ValueChanged<String> onCoachSelected;
  final ValueChanged<Seat> onSeatTapped;

  const SeatGridView({
    super.key,
    required this.selectedCoach,
    required this.seats,
    required this.selectedSeats,
    required this.passengers,
    required this.onCoachSelected,
    required this.onSeatTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final coaches = [
      {'number': '1', 'title': 'Coach 1 - First', 'avail': '2 left'},
      {'number': '3', 'title': 'Coach 3 - Business', 'avail': '6 left'},
      {'number': '6', 'title': 'Coach 6 - Economy', 'avail': '14 left'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Coach selection horizontal pills
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: coaches.length,
            itemBuilder: (context, index) {
              final coach = coaches[index];
              final isCoachSelected = coach['number'] == selectedCoach;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: isCoachSelected,
                  label: Text('${coach['title']} (${coach['avail']})'),
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isCoachSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : kColorPrimaryAction),
                  ),
                  backgroundColor:
                      isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
                  selectedColor: kColorPrimaryAction,
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (_) => onCoachSelected(coach['number']!),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Passenger Seat Assignment Chips
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.person_pin, size: 20, color: kColorAccentGold),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: passengers.map((p) {
                    final seatLabel = p.assignedSeat?.seatNumber ?? '---';
                    return Chip(
                      avatar: CircleAvatar(
                        backgroundColor: kColorAccentGold.withOpacity(0.2),
                        child: Text(
                          '${p.index}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: kColorAccentGold,
                          ),
                        ),
                      ),
                      label: Text(
                        '${p.fullName}: $seatLabel',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor:
                          isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Seat Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLegendItem(
              context: context,
              color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
              borderColor: const Color(0xFFE5E5EA),
              label: 'booking.seat_selection.available'.tr(),
            ),
            _buildLegendItem(
              context: context,
              color: kColorPrimaryAction,
              label: 'booking.seat_selection.selected'.tr(),
              textColor: Colors.white,
            ),
            _buildLegendItem(
              context: context,
              color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5EA),
              label: 'booking.seat_selection.occupied'.tr(),
            ),
            _buildLegendItem(
              context: context,
              color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
              borderColor: kColorAccentGold,
              icon: Icons.accessible,
              iconColor: kColorAccentGold,
              label: 'booking.seat_selection.accessible'.tr(),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Front Train Indicator
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_upward, size: 16, color: kColorSubtitle),
              const SizedBox(width: 8),
              Text(
                'booking.seat_selection.front'.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: kColorSubtitle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Seat Map Layout
        // Enforce TextDirection.ltr so seat letters A-D stay left-to-right matching train coach convention!
        Directionality(
          textDirection: ui.TextDirection.ltr,
          child: Column(
            children: _buildSeatRows(context),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required BuildContext context,
    required Color color,
    Color? borderColor,
    required String label,
    Color? textColor,
    IconData? icon,
    Color? iconColor,
  }) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor ?? Colors.transparent),
          ),
          child: icon != null
              ? Icon(icon, size: 14, color: iconColor)
              : null,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSeatRows(BuildContext context) {
    final Map<int, List<Seat>> seatRows = {};
    for (final seat in seats) {
      final rowNum = int.tryParse(seat.seatNumber.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
      seatRows.putIfAbsent(rowNum, () => []).add(seat);
    }

    final sortedRowKeys = seatRows.keys.toList()..sort();

    return sortedRowKeys.map((rowKey) {
      final rowSeats = seatRows[rowKey]!;
      Seat? seatA = rowSeats.cast<Seat?>().firstWhere(
            (s) => s?.seatNumber.endsWith('A') ?? false,
            orElse: () => null,
          );
      Seat? seatB = rowSeats.cast<Seat?>().firstWhere(
            (s) => s?.seatNumber.endsWith('B') ?? false,
            orElse: () => null,
          );
      Seat? seatC = rowSeats.cast<Seat?>().firstWhere(
            (s) => s?.seatNumber.endsWith('C') ?? false,
            orElse: () => null,
          );
      Seat? seatD = rowSeats.cast<Seat?>().firstWhere(
            (s) => s?.seatNumber.endsWith('D') ?? false,
            orElse: () => null,
          );

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSeatButton(context, seatA, '$rowKey A'),
            const SizedBox(width: 6),
            _buildSeatButton(context, seatB, '$rowKey B'),
            // Train Aisle Space
            SizedBox(
              width: 36,
              child: Center(
                child: Text(
                  '$rowKey',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: kColorSubtitle,
                  ),
                ),
              ),
            ),
            _buildSeatButton(context, seatC, '$rowKey C'),
            const SizedBox(width: 6),
            _buildSeatButton(context, seatD, '$rowKey D'),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildSeatButton(BuildContext context, Seat? seat, String fallbackNum) {
    if (seat == null) {
      return const SizedBox(width: 48, height: 48);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selectedSeats.any((s) => s.seatNumber == seat.seatNumber);
    final isOccupied = seat.isOccupied;

    Color bg;
    Color border;
    Color textColor;

    if (isOccupied) {
      bg = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);
      border = Colors.transparent;
      textColor = isDark ? Colors.white30 : const Color(0xFFAEAEB2);
    } else if (isSelected) {
      bg = kColorPrimaryAction;
      border = kColorPrimaryAction;
      textColor = Colors.white;
    } else {
      bg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
      border = seat.isAccessible ? kColorAccentGold : const Color(0xFFE5E5EA);
      textColor = isDark ? Colors.white : kColorPrimaryAction;
    }

    return Semantics(
      label: 'Seat ${seat.seatNumber}, ${isOccupied ? "Occupied" : (isSelected ? "Selected" : "Available")}',
      button: true,
      enabled: !isOccupied,
      child: GestureDetector(
        onTap: () => onSeatTapped(seat),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border, width: seat.isAccessible ? 2 : 1),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (seat.isAccessible)
                Icon(
                  Icons.accessible,
                  size: 14,
                  color: isSelected
                      ? Colors.white
                      : (isOccupied ? textColor : kColorAccentGold),
                )
              else
                Text(
                  seat.seatNumber,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
