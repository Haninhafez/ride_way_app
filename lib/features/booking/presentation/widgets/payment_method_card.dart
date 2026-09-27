import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/payment_method.dart';
import '../../../../core/themes/theme_data.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodType type;
  final PaymentMethodType selectedType;
  final ValueChanged<PaymentMethodType> onSelected;

  const PaymentMethodCard({
    super.key,
    required this.type,
    required this.selectedType,
    required this.onSelected,
  });

  IconData _getIcon() {
    switch (type) {
      case PaymentMethodType.mada:
        return Icons.credit_card;
      case PaymentMethodType.applePay:
        return Icons.apple;
      case PaymentMethodType.creditCard:
        return Icons.add_card;
      case PaymentMethodType.cashAtStation:
        return Icons.payments_outlined;
    }
  }

  String _getTitle() {
    switch (type) {
      case PaymentMethodType.mada:
        return 'booking.payment.saved_card'.tr();
      case PaymentMethodType.applePay:
        return 'booking.payment.apple_pay'.tr();
      case PaymentMethodType.creditCard:
        return 'booking.payment.new_card'.tr();
      case PaymentMethodType.cashAtStation:
        return 'booking.payment.cash_station'.tr();
    }
  }

  String? _getSubtitle() {
    switch (type) {
      case PaymentMethodType.mada:
        return 'booking.payment.expires'.tr();
      case PaymentMethodType.cashAtStation:
        return 'booking.payment.cash_subtitle'.tr();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = type == selectedType;
    final subtitle = _getSubtitle();

    return GestureDetector(
      onTap: () => onSelected(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? (isSelected ? const Color(0xFF2C2C2E) : const Color(0xFF1C1C1E))
              : (isSelected ? Colors.white : const Color(0xFFF9F9F9)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kColorPrimaryAction : (isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5EA)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Radio Indicator (Natively mirrors in RTL)
            Radio<PaymentMethodType>(
              value: type,
              groupValue: selectedType,
              activeColor: kColorPrimaryAction,
              onChanged: (val) {
                if (val != null) onSelected(val);
              },
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIcon(),
                size: 24,
                color: isDark ? Colors.white : kColorPrimaryAction,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTitle(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kColorPrimaryAction,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: kColorSubtitle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (type == PaymentMethodType.mada)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kColorSuccess.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'MADA',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: kColorSuccess,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
