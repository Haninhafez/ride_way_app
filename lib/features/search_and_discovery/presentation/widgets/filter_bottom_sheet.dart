import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/theme_data.dart';

class FilterBottomSheet extends StatefulWidget {
  final double? currentMaxPrice;
  final ValueChanged<double?> onApply;

  const FilterBottomSheet({
    super.key,
    required this.currentMaxPrice,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  double _price = 300.0;

  @override
  void initState() {
    super.initState();
    _price = widget.currentMaxPrice ?? 300.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'train_list.filter_title'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kColorPrimaryAction,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _price = 500.0);
                  widget.onApply(null);
                  Navigator.pop(context);
                },
                child: Text(
                  'train_list.reset_filters'.tr(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: kColorAccentGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${'train_list.max_price'.tr()}: SAR ${_price.toInt()}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : kColorPrimaryAction,
            ),
          ),
          Slider(
            value: _price,
            min: 100,
            max: 500,
            divisions: 8,
            activeColor: kColorPrimaryAction,
            inactiveColor: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5EA),
            label: 'SAR ${_price.toInt()}',
            onChanged: (val) => setState(() => _price = val),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_price);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimaryAction,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'train_list.apply_filters'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
