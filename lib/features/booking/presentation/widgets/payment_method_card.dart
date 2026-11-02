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
      case PaymentMethodType.vodafoneCash:
        return Icons.account_balance_wallet_outlined;
      case PaymentMethodType.creditCard:
        return Icons.add_card;
      case PaymentMethodType.cashAtStation:
        return Icons.payments_outlined;
    }
  }

  String _getTitle() {
    switch (type) {
      case PaymentMethodType.vodafoneCash:
        return 'booking.payment.apple_pay'.tr();
      case PaymentMethodType.creditCard:
        return 'booking.payment.new_card'.tr();
      case PaymentMethodType.cashAtStation:
        return 'booking.payment.cash_station'.tr();
    }
  }

  String? _getSubtitle() {
    switch (type) {
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

    final backgroundColor = isDark
        ? (isSelected ? const Color(0xFF2C2C2E) : const Color(0xFF1C1C1E))
        : (isSelected ? Colors.white : const Color(0xFFF9F9F9));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onSelected(type),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? kColorPrimaryAction
                    : (isDark
                          ? const Color(0xFF3A3A3C)
                          : const Color(0xFFE5E5EA)),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Radio<PaymentMethodType>(
                  value: type,
                  groupValue: selectedType,
                  activeColor: kColorPrimaryAction,
                  onChanged: (value) {
                    if (value != null) {
                      onSelected(value);
                    }
                  },
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF3A3A3C)
                        : const Color(0xFFF2F2F7),
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
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : kColorSubtitle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
