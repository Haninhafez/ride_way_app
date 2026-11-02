import 'dart:ui' as ui;
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/passenger.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/travel_class.dart';
import '../../../../core/themes/theme_data.dart';

class SeatGridView extends StatelessWidget {
  final List<TravelClass> classes;
  final String selectedClassId;
  final List<Seat> seats;
  final List<Seat> selectedSeats;
  final List<Passenger> passengers;
  final ValueChanged<TravelClass> onClassSelected;
  final ValueChanged<Seat> onSeatTapped;

  const SeatGridView({
    super.key,
    required this.classes,
    required this.selectedClassId,
    required this.seats,
    required this.selectedSeats,
    required this.passengers,
    required this.onClassSelected,
    required this.onSeatTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 55,
          child: Row(
            children: [
              Container(
                width: 70,

                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
                  border: Border.all(color: kColorSubtitleold, width: 1.5),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 30,
                    height: 15,
                    margin: const EdgeInsets.only(top: 6, left: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: kColorAccentGold, width: 1.5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: classes.length,
                  itemBuilder: (context, index) {
                    final travelClass = classes[index];
                    final isClassSelected = travelClass.id == selectedClassId;
                    final soldOut = travelClass.availableSeats == 0;

                    final carLabel = 'Car ${index + 1}';

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: soldOut
                            ? null
                            : () => onClassSelected(travelClass),
                        child: CustomPaint(
                          painter: soldOut
                              ? DashedBorderPainter(
                                  color: const Color(0xFF48484A),
                                  borderRadius: 16,
                                )
                              : null,
                          child: Container(
                            width: 72,
                            height: 52,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isClassSelected
                                  ? kColorAccentGold.withAlpha(15)
                                  : (soldOut
                                        ? Colors.transparent
                                        : const Color(
                                            0xFF2C2C2E,
                                          ).withAlpha(15)),
                              borderRadius: BorderRadius.circular(16),
                              border: isClassSelected
                                  ? Border.all(
                                      color: kColorAccentGold,
                                      width: 1.5,
                                    )
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  carLabel,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: soldOut
                                        ? const Color(0xFF636366)
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  travelClass.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: isClassSelected
                                        ? kColorAccentGold
                                        : const Color(0xFF8E8E93),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

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
              textColor: Colors.black,
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

        if (seats.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No seats available in this class.',
                style: TextStyle(color: kColorSubtitle),
              ),
            ),
          )
        else
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Column(children: _buildSeatRows(context)),
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
          child: icon != null ? Icon(icon, size: 14, color: iconColor) : null,
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
      if (seat.rowKey > 0) {
        seatRows.putIfAbsent(seat.rowKey, () => []).add(seat);
      }
    }

    final sortedRowKeys = seatRows.keys.toList()..sort();

    return sortedRowKeys.map((rowKey) {
      final rowSeats = seatRows[rowKey]!;

      Seat? seatIn(String col) =>
          rowSeats.where((s) => s.column == col).firstOrNull;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSeatButton(context, seatIn('A')),
            const SizedBox(width: 6),
            _buildSeatButton(context, seatIn('B')),
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
            _buildSeatButton(context, seatIn('C')),
            const SizedBox(width: 6),
            _buildSeatButton(context, seatIn('D')),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildSeatButton(BuildContext context, Seat? seat) {
    if (seat == null) {
      return const SizedBox(width: 48, height: 48);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selectedSeats.any(
      (s) => s.seatNumber == seat.seatNumber,
    );
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
      label:
          'Seat ${seat.seatNumber}, ${isOccupied ? "Occupied" : (isSelected ? "Selected" : "Available")}',
      button: true,
      enabled: !isOccupied,
      child: GestureDetector(
        onTap: isOccupied ? null : () => onSeatTapped(seat),
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
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                seat.seatNumber,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              if (seat.isAccessible) ...[
                const SizedBox(height: 2),
                Icon(
                  Icons.accessible,
                  size: 12,
                  color: isSelected
                      ? Colors.white
                      : (isOccupied ? textColor : kColorAccentGold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    required this.color,
    this.borderRadius = 16,
    this.strokeWidth = 1.2,
    this.dashWidth = 5,
    this.dashSpace = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}
