import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'filter_bottom_sheet.dart';
import '../../../../core/themes/theme_data.dart';

class SortFilterBar extends StatelessWidget {
  final String activeSort;
  final double? maxPriceFilter;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<double?> onFilterApplied;

  const SortFilterBar({
    super.key,
    required this.activeSort,
    required this.maxPriceFilter,
    required this.onSortChanged,
    required this.onFilterApplied,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sortOptions = [
      {'key': 'earliest', 'label': 'train_list.sort_earliest'.tr()},
      {'key': 'cheapest', 'label': 'train_list.sort_cheapest'.tr()},
      {'key': 'shortest', 'label': 'train_list.sort_shortest'.tr()},
    ];

    return Row(
      children: [
        // Filter Button
        OutlinedButton.icon(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (ctx) => FilterBottomSheet(
                currentMaxPrice: maxPriceFilter,
                onApply: onFilterApplied,
              ),
            );
          },
          icon: Icon(
            Icons.tune,
            size: 18,
            color: maxPriceFilter != null
                ? kColorAccentGold
                : (isDark ? Colors.white : kColorPrimaryAction),
          ),
          label: Text(
            'train_list.filters'.tr(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: maxPriceFilter != null
                  ? kColorAccentGold
                  : (isDark ? Colors.white : kColorPrimaryAction),
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            side: BorderSide(
              color: maxPriceFilter != null
                  ? kColorAccentGold
                  : (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA)),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
        ),
        const SizedBox(width: 8),

        // Sort Option Pills
        Expanded(
          child: SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: sortOptions.length,
              itemBuilder: (context, index) {
                final item = sortOptions[index];
                final isSelected = activeSort == item['key'];

                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Semantics(
                    toggled: isSelected,
                    label: '${item['label']}, sort option',
                    child: ChoiceChip(
                      selected: isSelected,
                      label: Text(item['label']!),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white70 : kColorPrimaryAction),
                      ),
                      backgroundColor:
                          isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
                      selectedColor: kColorPrimaryAction,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onSelected: (_) => onSortChanged(item['key']!),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
