import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/booking.dart';
import 'qr_code_widget.dart';
import '../../../../core/themes/theme_data.dart';

class PerforatedTicketCard extends StatelessWidget {
  final Booking booking;

  const PerforatedTicketCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateStr = DateFormat('EEE, d MMM').format(booking.travelDate);
    final seatNumbers = booking.passengers.map((p) => p.seatNumber).join(', ');

    return Column(
      children: [
        // Main Boarding Card Surface
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Dark Header Block
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: kColorPrimaryAction,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.directions_train, color: kColorAccentGold, size: 24),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.trainCode,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              booking.trainName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: kColorSubtitle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: kColorAccentGold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kColorAccentGold, width: 1),
                      ),
                      child: Text(
                        booking.travelClass,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: kColorAccentGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Light Body Block: Route Row & Grid Metadata
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Route Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: Text(
                                booking.origin,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : kColorPrimaryAction,
                                ),
                              ),
                            ),
                            Text(
                              booking.departureTime,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kColorSubtitle,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              booking.duration,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: kColorSubtitle,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const CircleAvatar(radius: 3, backgroundColor: kColorAccentGold),
                                Container(width: 40, height: 2, color: kColorAccentGold),
                                const Icon(Icons.train, size: 16, color: kColorAccentGold),
                                Container(width: 40, height: 2, color: kColorAccentGold),
                                const CircleAvatar(radius: 3, backgroundColor: kColorAccentGold),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: Text(
                                booking.destination,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : kColorPrimaryAction,
                                ),
                              ),
                            ),
                            Text(
                              booking.arrivalTime,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kColorSubtitle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),

                    // Grid Metadata Block
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildGridMeta('Date', dateStr, isDark),
                        _buildGridMeta('Platform', booking.platform, isDark),
                        _buildGridMeta('Coach', booking.coach, isDark),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildGridMeta('Passengers', '${booking.passengers.length}', isDark),
                        _buildGridMeta('Seats', seatNumbers, isDark),
                        _buildGridMeta('Total Paid', 'SAR ${booking.paymentSummary.totalPaid.toStringAsFixed(0)}', isDark),
                      ],
                    ),
                  ],
                ),
              ),

              // Perforated Tear Line with Semicircular Notches
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 20,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F131A) : kColorBackground,
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F131A) : kColorBackground,
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final count = (constraints.maxWidth / 10).floor();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            count,
                            (_) => Container(
                              width: 5,
                              height: 1.5,
                              color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5EA),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Bottom QR Code Container Block
              Padding(
                padding: const EdgeInsets.all(24),
                child: QRCodeWidget(
                  qrData: booking.qrCodeData,
                  bookingRef: booking.bookingRef,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGridMeta(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: kColorSubtitle,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : kColorPrimaryAction,
          ),
        ),
      ],
    );
  }
}
