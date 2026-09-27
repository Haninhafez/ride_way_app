import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/booking.dart';
import '../../../../core/themes/theme_data.dart';

class CancelBookingBottomSheet extends StatelessWidget {
  final Booking booking;
  final VoidCallback onConfirmCancel;

  const CancelBookingBottomSheet({
    super.key,
    required this.booking,
    required this.onConfirmCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final refundAmount = booking.paymentSummary.totalPaid;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5EA),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF2F2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              size: 36,
              color: Color(0xFFD93838),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'trips.refund_dialog_title'.tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : kColorPrimaryAction,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'trips.refund_dialog_msg'.tr(
              args: ['SAR ${refundAmount.toStringAsFixed(0)}'],
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: kColorSubtitle,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirmCancel();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD93838),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'trips.confirm_cancel'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'trips.keep_booking'.tr(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: kColorSubtitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
