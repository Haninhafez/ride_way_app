import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/booking_summary.dart';
import '../../../../core/themes/theme_data.dart';

class BookingSummaryCard extends StatelessWidget {
  final BookingSummary summary;

  const BookingSummaryCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
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
              const Icon(Icons.receipt_long, size: 20, color: kColorAccentGold),
              const SizedBox(width: 8),
              Text(
                'booking.summary.title'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kColorPrimaryAction,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRow('booking.summary.base_fare'.tr(), summary.subtotal, isDark),
          const SizedBox(height: 8),
          _buildRow('booking.summary.seat_reservation'.tr(), summary.seatReservationFee, isDark),
          const SizedBox(height: 8),
          _buildRow('booking.summary.service_fee'.tr(), summary.serviceFee, isDark),
          const SizedBox(height: 8),
          _buildRow('booking.summary.vat'.tr(), summary.vat, isDark),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'booking.summary.total'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kColorPrimaryAction,
                ),
              ),
              // Currency label "SAR 623" remains standard across both locales as specified
              Text(
                'SAR ${summary.grandTotal.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kColorPrimaryAction,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, double amount, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: kColorSubtitle,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'SAR ${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : kColorPrimaryAction,
          ),
        ),
      ],
    );
  }
}
